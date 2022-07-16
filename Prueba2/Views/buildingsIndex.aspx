<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="buildingsIndex.aspx.cs" Inherits="Prueba2.Views.buildingsIndex" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            var lst = function ({ callback = function (buildings) { } }) {
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

            var ins = function ({ nbuilding, callback = function (success) { } }) {
                $.ajax({
                    dataType: 'JSON',
                    type: 'POST',
                    url: '/Controllers/buildingsController.ashx',
                    data: {
                        accion: 'ins',
                        nbuilding: nbuilding
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

            var mod = function ({ id_building, nbuilding, callback = function (success) { } }) {
                $.ajax({
                    dataType: 'JSON',
                    type: 'POST',
                    url: '/Controllers/buildingsController.ashx',
                    data: {
                        accion: 'mod',
                        id_building: id_building,
                        nbuilding: nbuilding
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

            var del = function ({ id_building, callback = function (success) { } }) {
                $.ajax({
                    dataType: 'JSON',
                    type: 'POST',
                    url: '/Controllers/buildingsController.ashx',
                    data: {
                        accion: 'del',
                        id_building: id_building
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
                lst({
                    callback: function (buildings) {
                        let html = buildings.map(b => {
                            return `<tr data-md="${escapeHtml(JSON.stringify(b))}">
                                    <th scope="row">${b.id_building}</th>
                                    <td>${b.building}</td>
                                    <td><button name="bt_editar" class='btn btn-primary btn-sm'>Editar</button> <button name="bt_eliminar" class='btn btn-danger btn-sm'>Eliminar</button></td>
                                </tr>`;
                        }).join("");
                        $("#tb_lst tbody").html(html);
                    }
                });
            }

            $(document).on("click", "[name='bt_agregar']", async function (event) {
                event.preventDefault();
                const { value: nbuilding } = await Swal.fire({
                    title: 'Ingrese el nuevo edificio',
                    input: 'text',
                    inputPlaceholder: 'Nuevo nombre del edificio',
                    confirmButtonText: 'Aceptar',
                    cancelButtonText: 'Cancelar',
                    showCancelButton: true
                })

                if (nbuilding) {
                    ins({
                        nbuilding: nbuilding, callback: function () {
                            Swal.fire(
                                'Validación',
                                `${nbuilding} agregado`,
                                'success'
                            )
                            refreshList();
                        }
                    });
                }
            });
            $(document).on("click", "[name='bt_editar']", async function () {
                event.preventDefault();
                var data = $(this).parents("tr").data("md");
                const { value: nbuilding } = await Swal.fire({
                    title: 'Ingrese el nuevo edificio',
                    input: 'text',
                    inputPlaceholder: 'Nuevo nombre del edificio',
                    confirmButtonText: 'Aceptar',
                    cancelButtonText: 'Cancelar',
                    inputValue: data.building,
                    showCancelButton: true
                })

                if (nbuilding) {
                    mod({
                        id_building: data.id_building,
                        nbuilding: nbuilding, callback: function () {
                            Swal.fire('Validación',
                                `Nombre cambiado de ${data.building} a ${nbuilding}`,
                                'success');
                            refreshList();
                        }
                    });
                }
            });
            $(document).on("click", "[name='bt_eliminar']", function () {
                event.preventDefault();
                var data = $(this).parents("tr").data("md");
                Swal.fire({
                    title: `¿Desea eliminar el edificio ?`,
                    showCancelButton: true,
                    confirmButtonText: 'Eliminar',
                    cancelButtonText: 'Cancelar'
                }).then((result) => {
                    if (result.isConfirmed) {
                        del({
                            id_building: data.id_building, callback: function () {
                                Swal.fire(
                                    'Validación',
                                    `${data.building} eliminado`,
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
            <h3>Listado de edificios</h3>
        </div>
        <div class="col">
            <button name="bt_agregar" class='btn btn-success btn-sm'>Agregar</button>
        </div>
    </div>
    <table id="tb_lst" class="table">
        <thead>
            <tr>
                <th scope="col">ID</th>
                <th scope="col">Edificio</th>
                <th scope="col">Acciones</th>
            </tr>
        </thead>
        <tbody>
            
        </tbody>
    </table>
</asp:Content>
