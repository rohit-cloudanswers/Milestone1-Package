<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Service_Contract_Global_Search_Update</fullName>
        <description>Global Search Update</description>
        <field>Global_Search__c</field>
        <formula>IF(ISNUMBER(NULLVALUE(Oracle_Contract_Number__c,&quot;A&quot;)),TEXT(VALUE(Oracle_Contract_Number__c)),NULLVALUE(Oracle_Contract_Number__c,&quot; &quot;)) &amp; &quot; &quot; &amp; NULLVALUE(End_Customer_Account__r.Name, &quot; &quot;)</formula>
        <name>Service Contract Global Search Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Name_2_Field</fullName>
        <field>Account_Name_2__c</field>
        <formula>Account.Name</formula>
        <name>Update Account Name 2 Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Service Contract Global Search Field</fullName>
        <actions>
            <name>Service_Contract_Global_Search_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Global Search Field - populate with short contract # and end user account</description>
        <formula>OR(ISCHANGED(Oracle_Contract_Number__c), ISCHANGED( End_Customer_Account__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Update Account Name 2 Field</fullName>
        <actions>
            <name>Update_Account_Name_2_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ServiceContract.ContractNumber</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
