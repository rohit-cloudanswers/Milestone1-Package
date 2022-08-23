<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Jira_Issue_has_been_Updated</fullName>
        <description>Jira Issue has been Updated</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Automated_Processes/Jira_Issue_has_been_Updated</template>
    </alerts>
    <fieldUpdates>
        <fullName>Case_Last_Bug_Update</fullName>
        <description>Case Last Bug Update</description>
        <field>Last_Bug_Update__c</field>
        <formula>IF(ISBLANK(Bug_Number__c), &quot;Bug Number: &quot;, &quot;Bug Number: &quot; &amp; Bug_Number__c) 
&amp; BR() &amp; IF(ISBLANK(Status__c), &quot;Status: &quot;, &quot;Status: &quot;  &amp; Status__c) &amp; BR() &amp;
IF(ISBLANK(Fixed_Version_Number__c), &quot;Fixed Version Number: &quot;, &quot;Fixed Version Number: &quot;  &amp; Fixed_Version_Number__c) &amp; BR() &amp;
IF(ISBLANK(Planned_Completion__c), &quot;Planned Completion: &quot;, &quot;Planned Completion: &quot; &amp; TEXT(Planned_Completion__c))</formula>
        <name>Case Last Bug Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Bug_Status_with_Jira_Status</fullName>
        <description>When jira status changed, update the bug status</description>
        <field>Status__c</field>
        <formula>TEXT(Jira_Status__c)</formula>
        <name>Update Bug Status with Jira Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Bug_field</fullName>
        <field>Bug_s__c</field>
        <formula>IF(ISBLANK( Case__r.Bug_s__c ),    Bug_Number__c  , IF(CONTAINS ( Case__r.Bug_s__c,  Bug_Number__c  ), Case__r.Bug_s__c, Case__r.Bug_s__c + &quot;|&quot; +  Bug_Number__c ))</formula>
        <name>Update Bug # field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Integrated_Jira_Feature</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updated_by_Development</fullName>
        <field>Type__c</field>
        <literalValue>Updated by Development</literalValue>
        <name>Updated by Development</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Case Last Bug Update</fullName>
        <actions>
            <name>Case_Last_Bug_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Bug_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>MOVED TO PROCESS BUILDER Case Last Bug Update</description>
        <formula>AND ( OR ( ISNEW(), ISCHANGED(LastModifiedDate) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Record Type for Feature Request</fullName>
        <actions>
            <name>Update_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Bug__c.Issue_Type__c</field>
            <operation>equals</operation>
            <value>Feature Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Change Type to %22Updated by Development%22</fullName>
        <actions>
            <name>Updated_by_Development</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Bug__c.Operation_Code__c</field>
            <operation>equals</operation>
            <value>BUG_UPD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Bug__c.Operation_Code__c</field>
            <operation>equals</operation>
            <value>BUG_CMP</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Bug Status with Jira Status</fullName>
        <actions>
            <name>Update_Bug_Status_with_Jira_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>MOVED TO PROCESS BUILDER - When jira status changes, update bug status so shared lists are accurate</description>
        <formula>ISCHANGED( Jira_Status__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
