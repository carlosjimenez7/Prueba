<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="queryIndex.aspx.cs" Inherits="Prueba2.Views.queryIndex" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            var v_customers = [];
            var lst = function ({ available, callback = function (parts) { } }) {
                $.ajax({
                    dataType: 'JSON',
                    type: 'POST',
                    url: '/Controllers/queryController.ashx',
                    data: {
                        accion: 'lst',
                        available: available
                    }
                }).then(r => {
                    if (r.error) {
                        Swal.fire(
                            'Validación',
                            `No fue posible cargar los datos`,
                            'info'
                        );
                    } else {
                        callback(r.data);
                    }
                });
            }

            var refreshList = function () {
                $("#tb_lst tbody").html("Cargando...");
                lst({
                    available: $("#slAvailable").val(),
                    callback: function (parts) {
                        let html = parts.map(p => {
                            return `<tr data-md="${escapeHtml(JSON.stringify(p))}">
                                    <th scope="row">${p.id_partnumber}</th>
                                    <td>${p.partNumber}</td>
                                    <td>${p.customers}</td>
                                    <td>${p.available == "True" ? "SI" : "NO"}</td>
                                    <td>${p.building}</td>
                                </tr>`;
                        }).join("");
                        $("#tb_lst tbody").html(html);
                    }
                });
            }

            refreshList();

            $("#slAvailable").on('change', function () {
                refreshList();
            });

            $("#bt_export").click(function (e) {
                e.preventDefault();
                var table2excel = new Table2Excel();
                table2excel.export(document.querySelectorAll("#tb_lst"));
            });
        });
    </script>
    <div class="row">
        <div class="col">
            <h3>Consulta de partes</h3>
        </div>
        <div class="col">
            <div class="mb-3">
                <label for="slAvailable" class="form-label">Disponibles</label>
                <select class="form-select" id="slAvailable" aria-label="Disponibles">
                    <option value="1">SI</option>
                    <option value="0">NO</option>
                </select>
            </div>
        </div>
        <div class="col">
            <button id="bt_export" class='btn btn-success btn-sm'>Exportar a excel</button>
        </div>
    </div>
    <div id="dv_data">
        <table id="tb_lst" class="table">
            <thead>
                <tr>
                    <th scope="col">ID</th>
                    <th scope="col">Numero de parte</th>
                    <th scope="col">Cliente</th>
                    <th scope="col">Disponible</th>
                    <th scope="col">Edificio</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</asp:Content>
