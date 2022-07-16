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
    public class queryController : IHttpHandler
    {
        private JSONResponse jresponse;

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "Application/Json";
            HttpSessionState session = context.Session;
            HttpRequest request = context.Request;
            String accion = context.Request.Form["accion"];
            switch (accion)
            {
                case "lst":
                    context.Response.Write(lst(session, request, context));
                    break;
            }
        }

        private String lst(HttpSessionState SessionIDManager, HttpRequest request, HttpContext context)
        {
            jresponse = new JSONResponse();
            String available = context.Request.Form["available"];
            DataTable dt = null;
            try
            {

                dt = new DataTable();
                BD bd = new BD();
                dt.Load(bd.Query("select p.id_PartNumber, p.PartNumber, p.Available, c.id_Customers, c.Customers, c.Prefix, b.id_Building, b.Building from partNumbers p join Customers c on c.id_Customers = p.id_Customers join Buildings b on b.id_Building = c.id_Building where p.Available = " + available));
                jresponse.count = dt.Rows.Count;

                var lst = from dr in dt.AsEnumerable()
                          select new
                          {
                              id_partnumber = dr["id_partnumber"].ToString(),
                              partNumber = dr["partNumber"].ToString(),
                              available = dr["available"].ToString(),
                              id_customers = dr["id_customers"].ToString(),
                              customers = dr["customers"].ToString(),
                              prefix = dr["prefix"].ToString(),
                              id_building = dr["id_Building"].ToString(),
                              building = dr["building"].ToString()
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