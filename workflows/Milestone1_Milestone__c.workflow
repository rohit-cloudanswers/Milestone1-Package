<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Milestone_Global_Search2</fullName>
        <field>Global_Search__c</field>
        <formula>Project_Number__c &amp; &quot; &quot; &amp; Project_Name__c</formula>
        <name>Milestone Global Search2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ilestone Global Search2</fullName>
        <actions>
            <name>Milestone_Global_Search2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR( ISNEW(), ISCHANGED( Project_Name__c ), ISCHANGED( Project__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
