<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>MPM_Confirmed_Email2</fullName>
        <description>MPM Confirmed Email2</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MPM_Confirmed_Task_HTML</template>
    </alerts>
    <alerts>
        <fullName>MPM_Tentative_Task_HTML2</fullName>
        <description>MPM Tentative Task HTML2</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/MPM_Tentative_Task_HTML</template>
    </alerts>
    <alerts>
        <fullName>Milestone_Task_Assignment2</fullName>
        <description>Milestone Task Assignment2</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Milestone_Task_Assignment</template>
    </alerts>
    <rules>
        <fullName>Milestone Task Assignment2</fullName>
        <actions>
            <name>Milestone_Task_Assignment2</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>OR(AND(ISCHANGED( Assigned_To__c ), Assigned_To__r.Alias &lt;&gt; &apos;SBLBCDOR&apos;), AND(ISNEW(), Assigned_To__r.Alias &lt;&gt; &apos;SBLBCDOR&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PF Confirmed Task Stage2</fullName>
        <actions>
            <name>MPM_Confirmed_Email2</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(ISPICKVAL(Task_Stage__c, &quot;Confirmed&quot;),
CreatedById &lt;&gt; Assigned_To__c,
Assigned_To__r.Alias &lt;&gt; &apos;SBLBCDOR&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PF Tentative Task Stage 2</fullName>
        <actions>
            <name>MPM_Tentative_Task_HTML2</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(ISPICKVAL(Task_Stage__c, &quot;Tentative&quot;),
CreatedById &lt;&gt; Assigned_To__c,
Assigned_To__r.Alias &lt;&gt; &apos;SBLBCDOR&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
