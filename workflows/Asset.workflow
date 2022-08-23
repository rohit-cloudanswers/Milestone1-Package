<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Account_Last_Changed_Date_Today</fullName>
        <field>Account_Last_Changed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Account Last Changed Date Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_End_Cust_Last_Changed_Date_Today</fullName>
        <field>End_Customer_Last_Changed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update End Cust Last Changed Date Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Service%3A Update Asset Account Last Changed Date</fullName>
        <actions>
            <name>Update_Account_Last_Changed_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(AccountId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Update Asset End Customer Last Changed Date</fullName>
        <actions>
            <name>Update_End_Cust_Last_Changed_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( End_Customer__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
