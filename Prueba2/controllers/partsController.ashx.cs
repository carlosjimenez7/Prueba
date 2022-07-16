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
    /// Descripción breve de buildingsController
    /// </summary>
    public class partsController : IHttpHandler
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
                dt.Load(bd.Query("select * from partNumbers"));
                jresponse.count = dt.Rows.Count;

                var lst = from dr in dt.AsEnumerable()
                          select new
                          {
                              id_partnumber = dr["id_partnumber"].ToString(),
                              partNumber = dr["partNumber"].ToString(),
                              id_customers = dr["id_customers"].ToString(),
                              available = dr["available"].ToString()
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

            String partNumber = context.Request.Form["partNumber"];
            String id_customers = context.Request.Form["id_customers"];
            String available = context.Request.Form["available"];

            try
            {
                BD bd = new BD();
                jresponse.data = bd.Command("insert into partNumbers values('"+ partNumber + "', "+id_customers+", "+available+");");
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

            String id_partnumber = context.Request.Form["id_partnumber"];
            String partNumber = context.Request.Form["partNumber"];
            String id_customers = context.Request.Form["id_customers"];
            String available = context.Request.Form["available"];

            try
            {
                BD bd = new BD();
                jresponse.data = bd.Command("update partNumbers set partNumber='"+partNumber+"', id_customers=" + id_customers + ", available="+ available + "  where id_partnumber=" + id_partnumber + ";");
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

            String id_partnumber = context.Request.Form["id_partnumber"];

            try
            {
                BD bd = new BD();
                jresponse.data = bd.Command("delete from partNumbers where id_partnumber=" + id_partnumber + ";");
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