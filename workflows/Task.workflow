<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Activity_Type</fullName>
        <field>Activity_Type__c</field>
        <formula>TEXT(Type)</formula>
        <name>Update Activity Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Service%3A Update Activity Type</fullName>
        <actions>
            <name>Update_Activity_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
