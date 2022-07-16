using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Newtonsoft.Json;

namespace Prueba2.controllers
{
    /// <summary>
    /// Descripción breve de customersController
    /// </summary>
    public class customersController : IHttpHandler
    {
        private JSONResponse jresponse;

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "Application/Json";
            //context.Response.Write("Hola a todos");
            HttpSessionState session = context.Session;
            HttpRequest request = context.Request;
            String accion = context.Request.Form["accion"];
            switch (accion)
            {
                case "lst":
                    context.Response.Write(lst(session, request, context));
                    break;
                case "ins":
                    context.Response.Write(ins(session, request, context));
                    break;
                case "mod":
                    context.Response.Write(mod(session, request, context));
                    break;
                case "del":
                    context.Response.Write(del(session, request, context));
                    break;
            }
        }

        private String lst(HttpSessionState SessionIDManager, HttpRequest request, HttpContext context)
        {
            jresponse = new JSONResponse();
            DataTable dt = null;
            try
            {

                dt = new DataTable();
                BD bd = new BD();
                dt.Load(bd.Query("select * from customers"));
                jresponse.count = dt.Rows.Count;

                var lst = from dr in dt.AsEnumerable()
                          select new
                          {
                              id_customers = dr["id_customers"].ToString(),
                              customers = dr["customers"].ToString(),
                              prefix = dr["prefix"].ToString(),
                              id_building = dr["id_building"].ToString()
                          };
                jresponse.data = lst.ToList();
            }
            catch (Exception e)
            {
                jresponse.mensaje = e.Message;
                jresponse.error = true;
            }
            return jresponse.ToString();
        }

        private String ins(HttpSessionState SessionIDManager, HttpRequest request, HttpContext context)
        {
            jresponse = new JSONResponse();

            String ncustomers= context.Request.Form["ncustomers"];
            String prefix = context.Request.Form["prefix"];
            String id_building = context.Request.Form["id_building"];

            try
            {
                BD bd = new BD();
                jresponse.data = bd.Command("insert into customers values('"+ ncustomers + "', '"+prefix+"', "+id_building+");");
            }
            catch (Exception e)
            {
                jresponse.mensaje = e.Message;
                jresponse.error = true;
            }
            return jresponse.ToString();
        }

        private String mod(HttpSessionState SessionIDManager, HttpRequest request, HttpContext context)
        {
            jresponse = new JSONResponse();

            String id_customers = context.Request.Form["id_customers"];
            String ncustomers = context.Request.Form["ncustomers"];
            String prefix = context.Request.Form["prefix"];
            String id_building = context.Request.Form["id_building"];

            try
            {
                BD bd = new BD();
                jresponse.data = bd.Command("update customers set customers='" + ncustomers + "', prefix='"+prefix+ "', id_building="+ id_building + " where id_customers=" + id_customers + ";");
            }
            catch (Exception e)
            {
                jresponse.mensaje = e.Message;
                jresponse.error = true;
            }
            return jresponse.ToString();
        }

        private String del(HttpSessionState SessionIDManager, HttpRequest request, HttpContext context)
        {
            jresponse = new JSONResponse();

            String id_customers = context.Request.Form["id_customers"];

            try
            {
                BD bd = new BD();
                jresponse.data = bd.Command("delete from customers where id_customers=(" + id_customers + ");");
            }
            catch (Exception e)
            {
                jresponse.mensaje = e.Message;
                jresponse.error = true;
            }
            return jresponse.ToString();
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        private class JSONResponse
        {
            public bool error;
            public String mensaje;
            public Object data, data2;
            public int count;

            public JSONResponse()
            {
                error = false;
                mensaje = "";
                data = new Object();
                data2 = new object();
                count = 0;
            }

            public override String ToString()
            {
                return JsonConvert.SerializeObject(this);
            }
        }
    }
}