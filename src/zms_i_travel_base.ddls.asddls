@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view entity - Travel'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZMS_I_TRAVEL_BASE
  as select from zms_db_travel
  association [1..*] to /DMO/I_Overall_Status_VH as _Status on $projection.Status = _Status.OverallStatus
{
  key travel_id                                                             as TravelId,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Search.ranking: #HIGH
      @Semantics.text: true
      description                                                           as Description,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price                                                           as TotalPrice,
      currency_code                                                         as CurrencyCode,
      @Consumption.valueHelpDefinition: [{
          entity: {
              name: '/DMO/I_Overall_Status_VH',
              element: 'OverallStatus'
          }
      }]
      status                                                                as Status,

      //New fields
      concat_with_space(cast(total_price as abap.char(20)),currency_code,1) as price_with_currency,
      _Status._Text.Text                                                    as status_text,

      //Associations:
      _Status
}
