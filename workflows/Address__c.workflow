<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NameFieldUpdate</fullName>
        <field>Name</field>
        <formula>LEFT(Street_Address__c,80)</formula>
        <name>NameFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Address_Name_2_Field</fullName>
        <description>Update text field with address name</description>
        <field>Account_Name_2__c</field>
        <formula>Account_Service__r.Name</formula>
        <name>Update Address Name 2 Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Country_2_Field</fullName>
        <field>Country_2__c</field>
        <formula>TEXT(Country__c)</formula>
        <name>Update Country 2 Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Service%3A Update Address Name 2 Field</fullName>
        <actions>
            <name>Update_Address_Name_2_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Address__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update the Address Name text field for use when searching addresses, so that results can be returned/searched by the account name</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Update Country 2 Field</fullName>
        <actions>
            <name>Update_Country_2_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Address__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update the Country text field for use when searching addresses, so that results can be returned/searched by the country</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WF_UpdateAddressName</fullName>
        <actions>
            <name>NameFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(CONTAINS (Name, LEFT(Street_Address__c,69) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
