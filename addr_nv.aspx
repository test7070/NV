<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
    <head>
        <title></title>
        <script src="../script/jquery.min.js" type="text/javascript"></script>
        <script src='../script/qj2.js' type="text/javascript"></script>
        <script src='qset.js' type="text/javascript"></script>
        <script src='../script/qj_mess.js' type="text/javascript"></script>
        <script src='../script/mask.js' type="text/javascript"></script>
        <script src="../script/qbox.js" type="text/javascript"></script>
        <link href="../qbox.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
            this.errorHandler = null;
            function onPageError(error) {
                alert("An error occurred:\r\n" + error.Message);
            }
            isEditTotal = false;
            q_tables = 's';
            var q_name = "addr";
            var q_readonly = ['txtCustprice', 'txtDriverprice', 'txtDriverprice2', 'txtCommission', 'txtCommission2', 'txtSalesno', 'txtSales'];
            var q_readonlys = [];
            var bbmNum = [['txtCustprice', 10, 3], ['txtDriverprice', 10, 3], ['txtDriverprice2', 10, 3], ['txtCommission', 10, 3], ['txtCommission2', 10, 3], ['txtMiles', 10, 0]];
            var bbsNum = [['txtCustprice', 10, 3], ['txtDriverprice', 10, 3], ['txtDriverprice2', 10, 3], ['txtCommission', 10, 3], ['txtCommission2', 10, 3]];
            var bbmMask = [];
            var bbsMask = [];
            q_sqlCount = 6;
            brwCount = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'Datea';
            aPop = new Array(['txtProductno', 'lblProductno', 'ucc', 'noa,product', 'txtProductno,txtProduct', 'ucc_b.aspx']
                            , ['txtCaseuseno', 'lblCaseuse_nv', 'cust', 'noa,comp', 'txtCaseuseno,txtCaseuse', 'cust_b.aspx']
                            , ['txtSalesno_', '', 'addr', 'noa,addr', 'txtSalesno_,txtSales_', 'addr_b.aspx']);
            $(document).ready(function() {
                bbmKey = ['noa'];
                bbsKey = ['noa', 'noq'];
                q_brwCount();
                q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
            });
            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainForm(0);
            }
            function mainPost() {
                q_getFormat();
                q_mask(bbmMask);
                bbsMask = [['txtDatea', r_picd]];
                $('#txtNoa').change(function(e) {
                    $(this).val($.trim($(this).val()).toUpperCase());
                    if ($(this).val().length > 0) {
                        //if((/^(\w+|\w+\u002D\w+)$/g).test($(this).val())){
                        t_where = "where=^^ noa='" + $(this).val() + "'^^";
                        q_gt('addr', t_where, 0, 0, 0, "checkAddrno_change", r_accy);
                        /*}else{
                         Lock();
                         alert('編號只允許 英文(A-Z)、數字(0-9)及dash(-)。'+String.fromCharCode(13)+'EX: A01、A01-001');
                         Unlock();
                         }*/
                    }
                });
                $('#btnPrint').bind('contextmenu', function(e) {
                    e.preventDefault();
                    q_box("z_addr2.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";;" + r_accy, 'z_addr2', "95%", "95%", q_getMsg("popPrint"));
                });
            }
            function q_funcPost(t_func, result) {
                switch(t_func) {
                    case 'tre.import':
                        if (result.length == 0)
                            alert('No data!');
                        else
                            location.reload();
                        break;
                }
            }
            function q_boxClose(s2) {
                var ret;
                switch (b_pop) {
                    case q_name + '_s':
                        q_boxClose2(s2);
                        break;
                }
                b_pop = '';
            }
            function q_gtPost(t_name) {
                switch (t_name) {
                    case 'z_addr':
                        var as = _q_appendData("authority", "", true);
                        if (as[0] != undefined && (as[0].pr_run == "1" || as[0].pr_run == "true")) {
                            q_box("z_addr.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";;" + r_accy, 'z_addr', "95%", "95%", q_getMsg("popPrint"));
                            return;
                        }
                        q_box("z_addr2.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";;" + r_accy, 'z_addr2', "95%", "95%", q_getMsg("popPrint"));
                        break;
                    case 'checkAddrno_change':
                        var as = _q_appendData("addr", "", true);
                        if (as[0] != undefined) {
                            alert('已存在 ' + as[0].noa + ' ' + as[0].addr);
                        }
                        break;
                    case 'checkAddrno_btnOk':
                        var as = _q_appendData("addr", "", true);
                        if (as[0] != undefined) {
                            alert('已存在 ' + as[0].noa + ' ' + as[0].addr);
                            Unlock();
                            return;
                        } else {
                            wrServer($('#txtNoa').val());
                        }
                        break;
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                            $('#btnPlus').show();
                        break;
                }
            }
            function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;
                Unlock();
            }
            function btnOk() {
                var t_date = '';
                for (var i = 0; i < q_bbsCount; i++) {
                    if ($('#txtDatea_' + i).val() >= t_date) {
                        t_date = $('#txtDatea_' + i).val();
                        $('#txtCustprice').val($('#txtCustprice_' + i).val());
                        $('#txtDriverprice').val($('#txtDriverprice_' + i).val());
                        $('#txtDriverprice2').val($('#txtDriverprice2_' + i).val());
                        $('#txtCommission').val($('#txtCommission_' + i).val());
                        $('#txtCommission2').val($('#txtCommission2_' + i).val());
                        $('#txtSalesno').val($('#txtSalesno_' + i).val());
                        $('#txtSales').val($('#txtSales_' + i).val());
                    }
                }
                Lock();
                $('#txtNoa').val($.trim($('#txtNoa').val()));
               
                if (q_cur == 1) {
                    t_where = "where=^^ noa='" + $('#txtNoa').val() + "'^^";
                    q_gt('addr', t_where, 0, 0, 0, "checkAddrno_btnOk", r_accy);
                } else {
                    wrServer($('#txtNoa').val());
                }
            }
            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)
                    return;
                q_box('addr_s.aspx', q_name + '_s', "500px", "330px", q_getMsg("popSeek"));
            }
            function bbsAssign() {
                for (var i = 0; i < q_bbsCount; i++) {
                    $('#txtDriverprice2_' + i).change(function() {
                        sum();
                    });
                    $('#txtCommission_' + i).change(function() {
                        sum();
                    });
                    $('#txtCommission2_' + i).change(function() {
                        sum();
                    });
                }
                _bbsAssign();
            }
            function btnIns() {
                _btnIns();
                refreshBbm();
                $('#txtNoa').focus();
            }
            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;
                _btnModi();
                refreshBbm();
                $('#txtNoa').attr('readonly', 'readonly');
                $('#txtAddr').focus();
            }
            function btnPrint() {
                if (r_rank > 8)
                    q_box("z_addr.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";;" + r_accy, 'z_addr', "95%", "95%", q_getMsg("popPrint"));
                else
                    q_gt('authority', "where=^^ a.noa='z_addr' and a.sssno='" + r_userno + "'^^", 0, 0, 0, "z_addr", r_accy);
            }
            function wrServer(key_value) {
                var i;
                $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
                _btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
            }
            function bbsSave(as) {
                if (!as['datea']) {
                    as[bbsKey[1]] = '';
                    return;
                }
                q_nowf();
                as['typea'] = abbm2['productno'];
                as['custno'] = abbm2['caseuseno'];
                return true;
            }
            function sum() {
                for (var i = 0; i < q_bbsCount; i++) {
                    $('#txtCustprice_' +i).val(q_add(q_add($('#txtDriverprice2_' +i).val(),$('#txtCommission_' +i).val()),$('#txtCommission2_' +i).val()));
                }
            }
            function refresh(recno) {
                _refresh(recno);
                refreshBbm();
            }
            function refreshBbm() {
                if (q_cur == 1) {
                    $('#txtNoa').css('color', 'black').css('background', 'white').removeAttr('readonly');
                } else {
                    $('#txtNoa').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
                }
            }
            function readonly(t_para, empty) {
                _readonly(t_para, empty);
                if (q_cur == 1 || q_cur == 2)
                    $('#btnPlus_ds').removeAttr('disabled');
                else
                    $('#btnPlus_ds').attr('disabled', $('#btnPlus').attr('disabled'));
            }
            function btnMinus(id) {
                _btnMinus(id);
            }
            function btnPlus(org_htm, dest_tag, afield) {
                _btnPlus(org_htm, dest_tag, afield);
            }
            function q_appendData(t_Table) {
                return _q_appendData(t_Table);
            }
            function btnSeek() {
                _btnSeek();
            }
            function btnTop() {
                _btnTop();
            }
            function btnPrev() {
                _btnPrev();
            }
            function btnPrevPage() {
                _btnPrevPage();
            }
            function btnNext() {
                _btnNext();
            }
            function btnNextPage() {
                _btnNextPage();
            }
            function btnBott() {
                _btnBott();
            }
            function q_brwAssign(s1) {
                _q_brwAssign(s1);
            }
            function btnDele() {
                _btnDele();
            }
            function btnCancel() {
                _btnCancel();
            }
            function plus_ds() {
                var t_date = '';
                for (var i = 0; i < q_bbsCount; i++) {
                    t_date = $.trim($('#txtDatea_' + i).val()) > t_date ? $.trim($('#txtDatea_' + i).val()) : t_date;
                }
                var n = 0;
                if (t_date.length > 0)
                    for (var i = 0; i < q_bbsCount; i++) {
                        n += t_date == $.trim($('#txtDatea_' + i).val()) ? 1 : 0;
                    }
                var m = q_bbsCount;
                while (m + n > q_bbsCount) {
                    $('#btnPlus').click();
                }
                var d1 = new Date(parseInt(t_date.substr(0, 3)) + 1911, parseInt(t_date.substring(4, 6)) - 1, parseInt(t_date.substring(7, 9)));
                d1.setDate(d1.getDate() + 95);
                var t_newdate = (d1.getFullYear() - 1911) + '/' + (d1.getMonth() + 1 < 10 ? '0' : '') + (d1.getMonth() + 1) + '/01';
                for (var i = 0, j = 0; i < m; i++) {
                    if (t_date == $.trim($('#txtDatea_' + i).val())) {
                        $('#txtDatea_' + (m + j)).val(t_newdate);
                        $('#txtCustprice_' + (m + j)).val($.trim($('#txtCustprice_' + i).val()));
                        $('#txtDriverprice_' + (m + j)).val($.trim($('#txtDriverprice_' + i).val()));
                        $('#txtDriverprice2_' + (m + j)).val($.trim($('#txtDriverprice2_' + i).val()));
                        j++;
                    }
                }
            }
        </script>
        <style type="text/css">
            #dmain {
                overflow: hidden;
            }
            .dview {
                float: left;
                width: 500px;
                border-width: 0px;
            }
            .tview {
                border: 5px solid gray;
                font-size: medium;
                background-color: black;
            }
            .tview tr {
                height: 30px;
            }
            .tview td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: #FFFF66;
                color: blue;
            }
            .dbbm {
                float: left;
                width: 450px;
                /*margin: -1px;
                 border: 1px black solid;*/
                border-radius: 5px;
            }
            .tbbm {
                padding: 0px;
                border: 1px white double;
                border-spacing: 0;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: #cad3ff;
                width: 100%;
            }
            .tbbm tr {
                height: 35px;
            }
            .tbbm tr td {
                width: 20%;
            }
            .tbbm .tdZ {
                width: 1%;
            }
            td .schema {
                display: block;
                width: 95%;
                height: 0px;
            }
            .tbbm tr td span {
                float: right;
                display: block;
                width: 5px;
                height: 10px;
            }
            .tbbm tr td .lbl {
                float: right;
                color: blue;
                font-size: medium;
            }
            .tbbm tr td .lbl.btn {
                color: #4297D7;
                font-weight: bolder;
            }
            .tbbm tr td .lbl.btn:hover {
                color: #FF8F19;
            }
            .txt.c1 {
                width: 100%;
                float: left;
            }
            .txt.num {
                text-align: right;
            }
            .tbbm td {
                margin: 0 -1px;
                padding: 0;
            }
            .tbbm td input[type="text"] {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                float: left;
            }
            .tbbm select {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                font-size: medium;
            }
            .dbbs {
                width: 950px;
            }
            .tbbs a {
                font-size: medium;
            }
            .num {
                text-align: right;
            }
            input[type="text"], input[type="button"] {
                font-size: medium;
            }
        </style>
    </head>
    <body ondragstart="return false" draggable="false"
    ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
    ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
    ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
    >
        <div id="childForm1" style="display:none;position:absolute;background:pink;">
            <input type="button" style="position:absolute;width:40px;height:20px;font-size: 10px;" value="關閉"/>
            <iframe style="background:white;position:absolute;"></iframe>
        </div>
        <div id="childForm2" style="display:none;position:absolute;background:gray;">
            <input type="button" style="position:absolute;width:40px;height:20px;font-size: 10px;" value="關閉"/>
            <iframe style="background:white;position:absolute;"></iframe>
        </div>
        <!--#include file="../inc/toolbar.inc"-->
        <div id='dmain'>
            <div class="dview" id="dview" >
                <table class="tview" id="tview">
                    <tr>
                        <td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
                        <td align="center" style="width:100px; color:black;"><a id='vewNoa'> </a></td>
                        <td align="center" style="width:200px; color:black;"><a id='vewAddr'> </a></td>
                        <td align="center" style="width:150px; color:black;"><a id='vewProductno'> </a></td>
                    </tr>
                    <tr>
                        <td>
                        <input id="chkBrow.*" type="checkbox" />
                        </td>
                        <td style="text-align: center;" id='noa'>~noa</td>
                        <td style="text-align: left;" id='addr'>~addr</td>
                        <td style="text-align: left;" id='product'>~product</td>
                    </tr>
                </table>
            </div>
            <div class='dbbm'>
                <table class="tbbm"  id="tbbm">
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td class="tdZ"></td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblNoa' class="lbl"> </a></td>
                        <td colspan="2">
                        <input id="txtNoa" type="text" class="txt c1" />
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblAddr' class="lbl"> </a></td>
                        <td colspan="3">
                        <input id="txtAddr" type="text" class="txt c1" />
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblProductno' class="lbl btn"> </a></td>
                        <td colspan="3">
                        <input id="txtProductno" type="text" style="float:left; width:40%;"/>
                        <input id="txtProduct" type="text" style="float:left; width:60%;"/>
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id="lblCaseuse_nv" class="lbl btn">客戶</a></td>
                        <td colspan="3">
                        <input id="txtCaseuseno" type="text" style="float:left; width:40%;"/>
                        <input id="txtCaseuse" type="text" style="float:left; width:60%;"/>
                        </td>
                    </tr>
                    <tr>
                        <td><span> </span><a id='lblMiles' class="lbl"> </a></td>
                        <td>
                        <input id="txtMiles" type="text"  class="txt c1  num"/>
                        </td>
                    </tr>
                    <tr style="display: none">
                        <td><span> </span><a id='lblCurrent' class="lbl"> </a></td>
                    </tr>
                    <tr style="display: none">
                        <td><span> </span><a id='lblCustprice' class="lbl"> </a></td>
                        <td>
                        <input id="txtCustprice" type="text"  class="txt c1  num"/>
                        </td>
                    </tr>
                    <tr style="display: none">
                        <td><span> </span><a id='lblDriverprice' class="lbl"> </a></td>
                        <td>
                        <input id="txtDriverprice" type="text"  class="txt c1  num"/>
                        </td>
                    </tr>
                    <tr style="display: none">
                        <td><span> </span><a id='lblDriverprice2' class="lbl"> </a></td>
                        <td>
                        <input id="txtDriverprice2" type="text"  class="txt c1  num"/>
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td><span> </span><a id='lblCommission' class="lbl"> </a></td>
                        <td>
                        <input id="txtCommission" type="text"  class="txt c1  num"/>
                        </td>
                    </tr>
                    <tr style="display: none">
                        <td><span> </span><a id='lblCommission2' class="lbl"> </a></td>
                        <td>
                        <input id="txtCommission2" type="text"  class="txt c1  num"/>
                        </td>
                    </tr>
                    <tr style="display: none">
                        <td><span> </span><a id='lblSales' class="lbl"> </a></td>
                        <td colspan="2">
                        <input id="txtSalesno" type="text"  style="float:left; width:40%;"/>
                        <input id="txtSales" type="text"  style="float:left; width:60%;"/>
                        </td>
                    </tr>
                    <tr></tr>
                </table>
            </div>
        </div>
        <div class='dbbs'>
            <table id="tbbs" class='tbbs'>
                <tr style='color:white; background:#003366;' >
                    <td  align="center" style="width:30px;">
                    <input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;display:none;"  />
                    <input class="btn"  id="btnPlus_ds" type="button" value='+' style="font-weight: bold;display:none;color:darkgreen;" onclick="plus_ds()" />
                    </td>
                    <td align="center" style="width:80px;"><a id='lblDatea_s'> </a></td>
                    <td align="center" style="width:80px;"><a id='lblCustprice_s'> </a></td>
                    <td align="center" style="width:80px;"><a id='lblDriverprice2_nv'>服務費</a></td>
                    <td align="center" style="width:80px;"><a id='lblCommission_nv'>料身單價</a></td>
                    <td align="center" style="width:80px;"><a id='lblCommission2_nv'>客戶運費</a></td>
                    <td align="center" style="width:80px;"><a id='lblDriverprice_nv'>公司車運費</a></td>
                    <td align="center" style="width:80px;"><a id='lblSalesno_nv'>地點編號</a></td>
                    <td align="center" style="width:80px;"><a id='lblSales_nv'>地點</a></td>
                    <td align="center" style="width:150px;"><a id='lblMemo_s'> </a></td>
                </tr>
                <tr  style='background:#cad3ff;'>
                    <td align="center">
                    <input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
                    <input id="txtNoq.*" type="text" style="display: none;" />
                    </td>
                    <td >
                    <input type="text" id="txtDatea.*" style="width:95%;" />
                    </td>
                    <td><input type="text" id="txtCustprice.*" style="width:95%;text-align:right;" /></td>
                    <td >
                    <input type="text" id="txtDriverprice2.*" style="width:95%;text-align:right;" />
                    </td>
                    <td>
                    <input type="text" id="txtCommission.*" style="width:95%;text-align:right;" />
                    </td>
                    <td>
                    <input type="text" id="txtCommission2.*" style="width:95%;text-align:right;" />
                    </td>
                    <td >
                    <input type="text" id="txtDriverprice.*" style="width:95%;text-align:right;" />
                    </td>
                    <td >
                    <input type="text" id="txtSalesno.*" style="width:95%;text-align:left;" />
                    </td>
                    <td >
                    <input type="text" id="txtSales.*" style="width:95%;text-align:left;" />
                    </td>
                    <td >
                    <input type="text" id="txtMemo.*" style="width:95%;" />
                    </td>
                </tr>
            </table>
        </div>
        <input id="q_sys" type="hidden" />
    </body>
</html>