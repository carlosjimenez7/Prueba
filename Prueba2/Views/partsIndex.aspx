<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="partsIndex.aspx.cs" Inherits="Prueba2.Views.partsIndex" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            var v_customers = [];
            var lst = function ({ callback = function (parts) { } }) {
                $.ajax({
                    dataType: 'JSON',
                    type: 'POST',
                    url: '/Controllers/partsController.ashx',
                    data: {
                        accion: 'lst',
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

            var lstCustomers = function ({ callback = function (customers) { } }) {
                $.ajax({
                    dataType: 'JSON',
                    type: 'POST',
                    url: '/Controllers/customersController.ashx',
                    data: {
                        accion: 'lst',
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

            var ins = function ({ partNumber, id_customers, available, callback = function (success) { } }) {
                $.ajax({
                    dataType: 'JSON',
                    type: 'POST',
                    url: '/Controllers/partsController.ashx',
                    data: {
                        accion: 'ins',
                        partNumber: partNumber,
                        id_customers: id_customers,
                        available: available
                    }
                }).then(r => {
                    if (r.error) {
                        Swal.fire(
                            'Validación',
                            `No fue posible agregar`,
                            'info'
                        );
                    } else {
                        callback(r.data);
                    }
                });
            }

            var mod = function ({ partNumber, id_partnumber, id_customers, available, callback = function (success) { } }) {
                $.ajax({
                    dataType: 'JSON',
                    type: 'POST',
                    url: '/Controllers/partsController.ashx',
                    data: {
                        accion: 'mod',
                        id_partnumber: id_partnumber,
                        partNumber: partNumber,
                        id_customers: id_customers,
                        available: available
                    }
                }).then(r => {
                    if (r.error) {
                        Swal.fire(
                            'Validación',
                            `No fue posible modificar`,
                            'info'
                        );
                    } else {
                        callback(r.data);
                    }
                });
            }

            var del = function ({ id_partnumber, callback = function (success) { } }) {
                $.ajax({
                    dataType: 'JSON',
                    type: 'POST',
                    url: '/Controllers/partsController.ashx',
                    data: {
                        accion: 'del',
                        id_partnumber: id_partnumber
                    }
                }).then(r => {
                    if (r.error) {
                        Swal.fire(
                            'Validación',
                            `No fue posible eliminar`,
                            'info'
                        );
                    } else {
                        callback(r.data);
                    }
                });
            }

            var refreshList = function () {
                $("#tb_lst tbody").html("Cargando...");
                lstCustomers({
                    callback: function (customers) {
                        v_customers = customers;
                        lst({
                            callback: function (parts) {
                                let html = parts.map(p => {
                                    return `<tr data-md="${escapeHtml(JSON.stringify(p))}">
                                    <th scope="row">${p.id_partnumber}</th>
                                    <td>${p.partNumber}</td>
                                    <td>${v_customers.filter(b => b.id_customers == p.id_customers)[0].customers}</td>
                                    <td>${p.available=="True"?"SI":"NO"}</td>
                                    <td><button name="bt_editar" class='btn btn-primary btn-sm'>Editar</button> <button name="bt_eliminar" class='btn btn-danger btn-sm'>Eliminar</button></td>
                                </tr>`;
                                }).join("");
                                $("#tb_lst tbody").html(html);
                            }
                        });
                    }
                });
            }

            $(document).on("click", "[name='bt_agregar']", async function (event) {
                event.preventDefault();
                var html = `<div class="mb-3">
  <label for="txPartNum" class="form-label">Numero de parte</label>
  <input type="text" class="form-control" id="txPartNum" placeholder="Numero de parte">
</div>
<div class="mb-3">
  <label for="slCliente" class="form-label">Cliente</label>
  <select class="form-select" id="slCustomer" aria-label="Cliente">
  ${v_customers.map(b => '<option value="' + b.id_customers + '">' + b.customers + '</option>').join("")}
</select>
</div>
<div class="mb-3">
  <label for="slAvailable" class="form-label">Cliente</label>
  <select class="form-select" id="slAvailable" aria-label="Cliente">
<option value="1">SI</option>
<option value="0">NO</option>
</select>
</div>`;
                Swal.fire({
                    title: 'Ingrese la nueva parte',
                    html: html,
                    confirmButtonText: 'Aceptar',
                    cancelButtonText: 'Cancelar',
                    showCancelButton: true
                }).then((result) => {
                    if (result.isConfirmed) {
                        var vpartnum = $("#txPartNum").val();
                        var vid_customer = $("#slCustomer").val();
                        var vavalilable = $("#slAvailable").val();
                        if (vpartnum && vid_customer) {
                            ins({
                                partNumber: vpartnum,
                                available: vavalilable,
                                id_customers: vid_customer, callback: function () {
                                    Swal.fire(
                                        'Validación',
                                        `${vpartnum} agregado`,
                                        'success'
                                    )
                                    refreshList();
                                }
                            });
                        }
                    }
                });
            });
            $(document).on("click", "[name='bt_editar']", async function () {
                event.preventDefault();
                var data = $(this).parents("tr").data("md");
                var html = `<div class="mb-3">
  <label for="txPartNum" class="form-label">Numero de parte</label>
  <input type="text" class="form-control" id="txPartNum" placeholder="Numero de parte" value="${data.partNumber}">
</div>
<div class="mb-3">
  <label for="slCliente" class="form-label">Cliente</label>
  <select class="form-select" id="slCustomer" aria-label="Cliente">
  ${v_customers.map(p => '<option value="' + p.id_customers + '"' + (p.id_partnumber == data.id_partnumber ? "selected" : "") +'>' + p.customers + '</option>').join("")}
</select>
</div>
<div class="mb-3">
  <label for="slAvailable" class="form-label">Cliente</label>
  <select class="form-select" id="slAvailable" aria-label="Cliente">
<option ${(data.available=="True" ? "selected" : "") } value="1">SI</option>
<option ${(data.available != "True" ? "selected" : "") } value="0">NO</option>
</select>
</div>`;
                Swal.fire({
                    title: 'Ingrese los nuevos datos',
                    html: html,
                    confirmButtonText: 'Aceptar',
                    cancelButtonText: 'Cancelar',
                    showCancelButton: true
                }).then((result) => {
                    if (result.isConfirmed) {
                        var vpartnum = $("#txPartNum").val();
                        var vid_customer = $("#slCustomer").val();
                        var vavalilable = $("#slAvailable").val();
                        if (vpartnum && vid_customer) {
                            mod({
                                id_partnumber: data.id_partnumber,
                                partNumber: vpartnum,
                                available: vavalilable,
                                id_customers: vid_customer, callback: function () {
                                    Swal.fire(
                                        'Validación',
                                        `${vpartnum} modificado`,
                                        'success'
                                    )
                                    refreshList();
                                }
                            });
                        }
                    }
                });
            });
            $(document).on("click", "[name='bt_eliminar']", function () {
                event.preventDefault();
                var data = $(this).parents("tr").data("md");
                Swal.fire({
                    title: `¿Desea eliminar la parte ${data.partNumber}?`,
                    showCancelButton: true,
                    confirmButtonText: 'Eliminar',
                    cancelButtonText: 'Cancelar'
                }).then((result) => {
                    if (result.isConfirmed) {
                        del({
                            id_partnumber: data.id_partnumber, callback: function () {
                                Swal.fire(
                                    'Validación',
                                    `${data.partNumber} eliminado`,
                                    'success'
                                )
                                refreshList();
                            }
                        });
                    }
                })
            });

            refreshList();
        });
    </script>
    <div class="row">
        <div class="col">
            <h3>Listado de partes</h3>
        </div>
        <div class="col">
            <button name="bt_agregar" class='btn btn-success btn-sm'>Agregar</button>
        </div>
    </div>
    <table id="tb_lst" class="table">
        <thead>
            <tr>
                <th scope="col">ID</th>
                <th scope="col">Numero de parte</th>
                <th scope="col">Cliente</th>
                <th scope="col">Disponible</th>
                <th scope="col">Acciones</th>
            </tr>
        </thead>
        <tbody>
            
        </tbody>
    </table>
</asp:Content>
