public with sharing class QuoteLineItemWrapper implements Comparable {
	public QuoteLineItem q{get;set;}
	public Boolean selected{get;set;}
	public Integer ordering{get;set;}
	public QuoteLineItemWrapper(QuoteLineItem q)
	{
		this.q = q;
	}
	public QuoteLineItemWrapper(){}
	
	public Integer compareTo(Object o)
	{
		QuoteLineItemWrapper that = (QuoteLineItemWrapper)o;
		system.debug('this.ordering '+this.ordering+' that ordering '+that.ordering);
		if(that.ordering < this.ordering)
		{
			return -1;
		}
		else if(this.ordering > that.ordering)
		{
			return 1;
		}
		else
		{
			return 0;
		}	
	}
}