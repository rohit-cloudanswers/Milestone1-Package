trigger trigger_ContractLineItem on ContractLineItem (before insert) {
    blogic_ContractLineItem.addDummyPriceBookEntry(trigger.new);
}