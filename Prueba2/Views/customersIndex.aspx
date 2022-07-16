<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="customersIndex.aspx.cs" Inherits="Prueba2.Views.customersIndex" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            var v_buildings = [];

            var lstBuildings = function ({ callback = function (buildings) { } }) {
                $.ajax({
                    dataType: 'JSON',
                    type: 'POST',
                    url: '/Controllers/buildingsController.ashx',
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

            var lst = function ({ callback = function (customers) { } }) {
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

            var ins = function ({ ncustomers, prefix, id_building, callback = function (success) { } }) {
                $.ajax({
                    dataType: 'JSON',
                    type: 'POST',
                    url: '/Controllers/customersController.ashx',
                    data: {
                        accion: 'ins',
                        ncustomers: ncustomers,
                        prefix: prefix,
                        id_building: id_building
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

            var mod = function ({ id_customers, ncustomers, prefix, id_building, nbuilding, callback = function (success) { } }) {
                $.ajax({
                    dataType: 'JSON',
                    type: 'POST',
                    url: '/Controllers/customersController.ashx',
                    data: {
                        accion: 'mod',
                        id_customers: id_customers,
                        ncustomers: ncustomers,
                        prefix: prefix,
                        id_building: id_building
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

            var del = function ({ id_customers, callback = function (success) { } }) {
                $.ajax({
                    dataType: 'JSON',
                    type: 'POST',
                    url: '/Controllers/customersController.ashx',
                    data: {
                        accion: 'del',
                        id_customers: id_customers
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
                lstBuildings({
                    callback: function (buildings) {
                        v_buildings = buildings;
                        lst({
                            callback: function (customers) {
                                let html = customers.map(c => {
                                    return `<tr data-md="${escapeHtml(JSON.stringify(c))}">
                                    <th scope="row">${c.id_customers}</th>
                                    <td>${c.customers}</td>
                                    <td>${c.prefix}</td>
                                    <td>${v_buildings.filter(b => b.id_building == c.id_building)[0].building}</td>
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
  <label for="txCliente" class="form-label">Cliente</label>
  <input type="text" class="form-control" id="txCliente" placeholder="Nombre del cliente">
</div>
<div class="mb-3">
  <label for="txPrefix" class="form-label">Prefijo</label>
  <input type="text" class="form-control" id="txPrefix" placeholder="Prefijo del cliente">
</div>
<div class="mb-3">
  <label for="txPrefix" class="form-label">Edificio</label>
  <select class="form-select" id="slEdificio" aria-label="Edificio">
  ${v_buildings.map(b => '<option value="'+b.id_building+'">'+b.building+'</option>').join("")}
</select>
</div>`;
                Swal.fire({
                    title: 'Ingrese el nuevo cliente',
                    html: html,
                    confirmButtonText: 'Aceptar',
                    cancelButtonText: 'Cancelar',
                    showCancelButton: true
                }).then((result) => {
                    if (result.isConfirmed) {
                        var vcustomer = $("#txCliente").val();
                        var vprefix = $("#txPrefix").val();
                        var vid_building = $("#slEdificio").val();
                        console.log({ vcustomer , vprefix , vid_building});
                        if (vcustomer && vprefix && vid_building) {
                            ins({
                                ncustomers: vcustomer,
                                prefix: vprefix,
                                id_building: vid_building, callback: function () {
                                    Swal.fire(
                                        'Validación',
                                        `${vcustomer} agregado`,
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
  <label for="txCliente" class="form-label">Cliente</label>
  <input type="text" class="form-control" id="txCliente" placeholder="Nombre del cliente" value="${data.customers}">
</div>
<div class="mb-3">
  <label for="txPrefix" class="form-label">Prefijo</label>
  <input type="text" class="form-control" id="txPrefix" placeholder="Prefijo del cliente" value="${data.prefix}">
</div>
<div class="mb-3">
  <label for="txPrefix" class="form-label">Edificio</label>
  <select class="form-select" id="slEdificio" aria-label="Edificio">
  ${v_buildings.map(b => '<option value="' + b.id_building + '" ' + (b.id_building == data.id_building ? "selected" : "")+'>' + b.building + '</option>').join("")}
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
                        var vcustomer = $("#txCliente").val();
                        var vprefix = $("#txPrefix").val();
                        var vid_building = $("#slEdificio").val();
                        console.log({ vcustomer, vprefix, vid_building });
                        if (vcustomer && vprefix && vid_building) {
                            mod({
                                id_customers: data.id_customers,
                                ncustomers: vcustomer,
                                prefix: vprefix,
                                id_building: vid_building, callback: function () {
                                    Swal.fire(
                                        'Validación',
                                        `${vcustomer} modificado`,
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
                    title: `¿Desea eliminar el cliente ${data.id_customers}?`,
                    showCancelButton: true,
                    confirmButtonText: 'Eliminar',
                    cancelButtonText: 'Cancelar'
                }).then((result) => {
                    if (result.isConfirmed) {
                        del({
                            id_customers: data.id_customers, callback: function () {
                                Swal.fire(
                                    'Validación',
                                    `${data.customers} eliminado`,
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
            <h3>Listado de clientes</h3>
        </div>
        <div class="col">
            <button name="bt_agregar" class='btn btn-success btn-sm'>Agregar</button>
        </div>
    </div>
    <table id="tb_lst" class="table">
        <thead>
            <tr>
                <th scope="col">ID</th>
                <th scope="col">Cliente</th>
                <th scope="col">Prefijo</th>
                <th scope="col">Edificio</th>
                <th scope="col">Acciones</th>
            </tr>
        </thead>
        <tbody>
            
        </tbody>
    </table>
</asp:Content>
