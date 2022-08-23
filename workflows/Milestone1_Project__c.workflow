<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Latest_Arrival_Onsite_Date_Calculation_2</fullName>
        <field>Latest_Arrival_Onsite_Date__c</field>
        <formula>PM_Orig_Rev_Rec_Date__c - 28</formula>
        <name>Latest Arrival Onsite Date Calculation 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Project 2%3A Latest Arrival Onsite Date</fullName>
        <actions>
            <name>Latest_Arrival_Onsite_Date_Calculation_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>(ISCHANGED(PM_Orig_Rev_Rec_Date__c) &amp;&amp; ISBLANK( Latest_Arrival_Onsite_Date__c )) ||
(NOT(ISBLANK(PM_Orig_Rev_Rec_Date__c)) &amp;&amp; ISBLANK( Latest_Arrival_Onsite_Date__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
