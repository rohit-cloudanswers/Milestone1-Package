<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Quote_Line_Item_Blank_Solution</fullName>
        <description>Quote Line Item - Blank Solution</description>
        <protected>false</protected>
        <recipients>
            <recipient>wolfram.hedewig@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Quote_Line_Item_Solution_Blank</template>
    </alerts>
    <alerts>
        <fullName>Quote_Line_Rounding_Error</fullName>
        <description>Quote Line Rounding Error</description>
        <protected>false</protected>
        <recipients>
            <recipient>help@cloudanswers.com.imagine</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lane.lobaugh@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Quote_Rounding_Alert</template>
    </alerts>
    <alerts>
        <fullName>Temporary_Product_Used_Alert</fullName>
        <description>Temporary Product Used Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>chip.schneider@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>gregory.smith@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lane.lobaugh@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>misum.qasim@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mohammad.samadi@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Temporary_Product_Used_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>Copy_Extended_Cost</fullName>
        <field>Extended_Cost_Copy__c</field>
        <formula>Extended_Cost__c</formula>
        <name>Copy Extended Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Product_Type</fullName>
        <field>Product_Type_copy__c</field>
        <formula>Product_Type__c</formula>
        <name>Copy Product Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_value_for_PS_Product_Type</fullName>
        <field>Net_List_Price_Currency_PS__c</field>
        <formula>Net_List_Price_Currency__c</formula>
        <name>Copy value for PS Product Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_value_for_Support_Product_Type</fullName>
        <field>Net_List_Price_Currency_Support__c</field>
        <formula>Net_List_Price_Currency__c</formula>
        <name>Copy value for Support Product Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Professional_Service_Flag_Update</fullName>
        <field>Professional_Service_Product__c</field>
        <literalValue>1</literalValue>
        <name>Professional Service Flag Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Flag_Change_Update</fullName>
        <field>Support_Product__c</field>
        <literalValue>1</literalValue>
        <name>Support Flag Change Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateHardwareDiscount</fullName>
        <field>Updated_At__c</field>
        <literalValue>Quote Line Item</literalValue>
        <name>UpdateHardwareDiscount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateSoftwareDiscount</fullName>
        <field>Updated_At__c</field>
        <literalValue>Quote Line Item</literalValue>
        <name>UpdateSoftwareDiscount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Cost</fullName>
        <field>Product_Cost2__c</field>
        <formula>IF(Product_Type__c = &apos;Support&apos;, UnitPrice * Cost_Percent__c,Product2.Product_Cost__c)</formula>
        <name>Update Product Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Description</fullName>
        <field>Long_Description__c</field>
        <formula>Product2.Description</formula>
        <name>Update Product Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SupportType</fullName>
        <field>Support_Type_Text__c</field>
        <formula>TEXT(Quote.Support_Type__c)</formula>
        <name>Update SupportType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy price for PS</fullName>
        <actions>
            <name>Copy_Product_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_value_for_PS_Product_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>QuoteLineItem.Product_Type__c</field>
            <operation>equals</operation>
            <value>Professional Services</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy price for support</fullName>
        <actions>
            <name>Copy_Product_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_value_for_Support_Product_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>QuoteLineItem.Product_Type__c</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy_Extended_Cost</fullName>
        <actions>
            <name>Copy_Extended_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Id&lt;&gt;null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Product Cost</fullName>
        <actions>
            <name>Update_Product_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>QuoteLineItem.Product_Cost2__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate Product Description</fullName>
        <actions>
            <name>Update_Product_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>QuoteLineItem.Long_Description__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>JTK - Workflow to populate the Long Description field on Quote Line Items with the Product Description field based on the Product selected.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Professional Services Flag Update</fullName>
        <actions>
            <name>Professional_Service_Flag_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>QuoteLineItem.Product_Type__c</field>
            <operation>equals</operation>
            <value>Professional Services</value>
        </criteriaItems>
        <description>his workflow will update the Professional Services Flag to TRUE on the quote line item if the Product Type equals &quot;Professional Services&quot;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Quote Line Item - Solution Blank</fullName>
        <actions>
            <name>Quote_Line_Item_Blank_Solution</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>QuoteLineItem.Solution_Set_Name__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Support Flag Update</fullName>
        <actions>
            <name>Support_Flag_Change_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>QuoteLineItem.Product_Type__c</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <description>This workflow will update the Support Flag to TRUE on the quote line item if the Product Type equals &quot;Support&quot;.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Temporary Product Used Alert</fullName>
        <actions>
            <name>Temporary_Product_Used_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.ProductCode</field>
            <operation>equals</operation>
            <value>IC-HW,IC-SW,IC-SVC,IC-NET-HW,IC-NET-SW,IC-PLY-HW,IC-PLY-SW</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update SupportType</fullName>
        <actions>
            <name>Update_SupportType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
