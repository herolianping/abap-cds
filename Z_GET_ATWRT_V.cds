@AbapCatalog.sqlViewName: 'Z_GET_ATWRT_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '获取物料批次特征'
define view Z_GET_BACTH_CHARACTERISTIC
  as select from    inob
    inner join      ausp  on ausp.objek = inob.cuobj
    inner join      cabn  on cabn.atinn = ausp.atinn
    left outer join cawn  on  cawn.atinn = cabn.atinn
                          and cawn.atwrt = ausp.atwrt
    left outer join cawnt on  cawnt.atinn = cawn.atinn
                          and cawnt.atzhl = cawn.atzhl
                          and cawnt.spras       = $session.system_language
  association [0..1] to cabnt on  cabnt.atinn = cabn.atinn
                              and cabnt.spras   = $session.system_language

{
  substring( inob.objek, 1, 40 ) as matnr,
  substring( inob.objek, 41,4 )  as werks,
  substring( inob.objek, 45,10 ) as charg,
  ausp.klart,
  inob.cuobj,
  ausp.atinn,
  cabn.atnam,
  cabnt.atbez,
  case cabn.atfor
  when 'CHAR'
      then ausp.atwrt
  when 'NUM'
        then   cast(
      case cabn.anzdz
        when 0
          then cast( fltp_to_dec( ausp.atflv as abap.dec( 13,0) )  as atwrt )
        when 2
          then cast( fltp_to_dec( ausp.atflv as abap.dec( 13,2) )  as atwrt )
        when 3
          then cast( fltp_to_dec( ausp.atflv as abap.dec( 13,3) )  as atwrt )
        end as atwrt
          )
  when 'DATE'
      then cast( ausp.date_from as atwrt )
  when 'TIME'
      then cast( ausp.time_from as atwrt )
  when 'CURR'
      then cast( ausp.curr_value_from as atwrt )
   end                           as tzval,
  cawnt.atwtb                    as tzdsc,
  cabn.unit
}
where
      inob.klart = '022'
  and inob.obtab = 'MCHA'
  and ausp.mafid = 'O'

