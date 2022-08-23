<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Azure_Critical_AfterHours_Notification_Alert</fullName>
        <description>Azure Critical AfterHours Notification Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>darcie.laur@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sadeek.mohamed@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Automatic_Workflow_Templates/Azure_Critical_Event_Notification</template>
    </alerts>
    <alerts>
        <fullName>Azure_Critical_Notification_Alert</fullName>
        <description>Azure Critical Notification Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>darcie.laur@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sadeek.mohamed@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Automatic_Workflow_Templates/Azure_Critical_Event_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Closed_Notification</fullName>
        <description>Case Closed Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Alternate_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Email_Templates/X30_Day_Reminder_with_Closure_and_Survey</template>
    </alerts>
    <alerts>
        <fullName>Case_Closed_Notification_Without_Survey</fullName>
        <description>Case Closed Notification Without Survey</description>
        <protected>false</protected>
        <recipients>
            <field>Alternate_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Email_Templates/X30_Day_Reminder_with_Closure</template>
    </alerts>
    <alerts>
        <fullName>Case_Closure</fullName>
        <description>Case Closure</description>
        <protected>false</protected>
        <recipients>
            <field>Alternate_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Email_Templates/Closure_with_Survey</template>
    </alerts>
    <alerts>
        <fullName>Case_Closure_Without_Survey</fullName>
        <description>Case Closure Without Survey</description>
        <protected>false</protected>
        <recipients>
            <field>Alternate_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Email_Templates/Closure_without_Survey</template>
    </alerts>
    <alerts>
        <fullName>Case_Creation_Notification</fullName>
        <description>Case Creation Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Alternate_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Email_Templates/Receipt</template>
    </alerts>
    <alerts>
        <fullName>Case_Enhancement_Type_Notification</fullName>
        <description>Case Enhancement Type Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Alternate_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Email_Templates/Enhancement_with_RFC_Attached</template>
    </alerts>
    <alerts>
        <fullName>Case_Status_Change_Notification</fullName>
        <description>Case Status Change Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Alternate_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Email_Templates/Status_Change</template>
    </alerts>
    <alerts>
        <fullName>Case_Status_of_Pending_External_Response_for_15_Days_Notification</fullName>
        <description>Case Status of Pending External Response for 15 Days Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Alternate_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Email_Templates/X15_Day_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Case_Weighting_Change_Alert</fullName>
        <description>Case Weighting Change Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Automated_Processes/Case_Weight_has_been_updated</template>
    </alerts>
    <alerts>
        <fullName>Critical_Case_Closed_Notification</fullName>
        <description>Critical Case Closed Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Product_Alert_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>clayton.benz@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Critical_Case_Closed</template>
    </alerts>
    <alerts>
        <fullName>Critical_Case_Creation_Notification</fullName>
        <description>Critical Case Creation Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Product_Alert_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>clayton.benz@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>gregory.weitz@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michael.laraia@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Critical_Case_Creation</template>
    </alerts>
    <alerts>
        <fullName>Critical_Case_Update_Notification</fullName>
        <description>Critical Case Update Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Product_Alert_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>clayton.benz@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>gregory.weitz@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michael.laraia@imaginecommunications.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Critical_Case_Update</template>
    </alerts>
    <alerts>
        <fullName>Initial_Update_SLA_Violation_Email</fullName>
        <ccEmails>Clayton.Benz@imaginecommunications.com</ccEmails>
        <ccEmails>Gregory.Weitz@imaginecommunications.com</ccEmails>
        <ccEmails>Carmel.Meyer@imaginecommunications.com</ccEmails>
        <ccEmails>darcie.laur@imaginecommunications.com</ccEmails>
        <description>Initial Update: SLA Violation Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Initial_Update_Violation</template>
    </alerts>
    <alerts>
        <fullName>Notify_Case_owner</fullName>
        <description>Notify Case owner on Customer Chatter Post</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Automated_Processes/Notify_Case_Owner_on_Customer_Chatter_Post</template>
    </alerts>
    <alerts>
        <fullName>Resolution_SLA_Violation_Email_Critical</fullName>
        <description>Resolution: SLA Violation Email - Critical</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Product_Alert_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Resolution_SLA_Violation_Email_Critical</template>
    </alerts>
    <alerts>
        <fullName>Resolution_SLA_Violation_Email_Custom</fullName>
        <ccEmails>Clayton.Benz@imaginecommunications.com</ccEmails>
        <ccEmails>Gregory.Weitz@imaginecommunications.com</ccEmails>
        <ccEmails>Carmel.Meyer@imaginecommunications.com</ccEmails>
        <ccEmails>darcie.laur@imaginecommunications.com</ccEmails>
        <description>Resolution: SLA Violation Email - Custom</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Restore_Violation</template>
    </alerts>
    <alerts>
        <fullName>Resolution_SLA_Violation_Email_HML</fullName>
        <description>Resolution: SLA Violation Email - HML</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Resolution_SLA_Violation_Email_HML</template>
    </alerts>
    <alerts>
        <fullName>Resolution_Upcoming_SLA_Violation_Email_Critical</fullName>
        <description>Resolution: Upcoming SLA Violation Email - Critical</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Resolution_SLA_Upcoming_Violation_Email_Critical</template>
    </alerts>
    <alerts>
        <fullName>Resolution_Upcoming_SLA_Violation_Email_Custom</fullName>
        <ccEmails>Clayton.Benz@imaginecommunications.com</ccEmails>
        <ccEmails>Gregory.Weitz@imaginecommunications.com</ccEmails>
        <ccEmails>Carmel.Meyer@imaginecommunications.com</ccEmails>
        <ccEmails>darcie.laur@imaginecommunications.com</ccEmails>
        <description>Resolution: Upcoming SLA Violation Email - Custom</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Resolution_Upcoming</template>
    </alerts>
    <alerts>
        <fullName>Resolution_Upcoming_SLA_Violation_Email_HML</fullName>
        <description>Resolution: Upcoming SLA Violation Email - HML</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Resolution_SLA_Upcoming_Violation_Email_HML</template>
    </alerts>
    <alerts>
        <fullName>Response_SLA_Violation_Email_Critical</fullName>
        <description>Response: SLA Violation Email - Critical</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Product_Alert_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Response_SLA_Violation_Email_Critical</template>
    </alerts>
    <alerts>
        <fullName>Response_SLA_Violation_Email_Custom</fullName>
        <ccEmails>Clayton.Benz@imaginecommunications.com</ccEmails>
        <ccEmails>Gregory.Weitz@imaginecommunications.com</ccEmails>
        <ccEmails>Carmel.Meyer@imaginecommunications.com</ccEmails>
        <ccEmails>darcie.laur@imaginecommunications.com</ccEmails>
        <description>Response: SLA Violation Email - Custom</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Response_Violation</template>
    </alerts>
    <alerts>
        <fullName>Response_SLA_Violation_Email_HML</fullName>
        <description>Response: SLA Violation Email - HML</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Response_SLA_Violation_Email_HML</template>
    </alerts>
    <alerts>
        <fullName>Response_Upcoming_SLA_Violation_Email_Critical</fullName>
        <description>Response: Upcoming SLA Violation Email - Critical</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Response_SLA_Upcoming_Violation_Email_Critical</template>
    </alerts>
    <alerts>
        <fullName>Response_Upcoming_SLA_Violation_Email_Custom</fullName>
        <ccEmails>Clayton.Benz@imaginecommunications.com</ccEmails>
        <ccEmails>Gregory.Weitz@imaginecommunications.com</ccEmails>
        <ccEmails>Carmel.Meyer@imaginecommunications.com</ccEmails>
        <ccEmails>darcie.laur@imaginecommunications.com</ccEmails>
        <description>Response: Upcoming SLA Violation Email - Custom</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Response_Upcoming</template>
    </alerts>
    <alerts>
        <fullName>Response_Upcoming_SLA_Violation_Email_HML</fullName>
        <description>Response: Upcoming SLA Violation Email - HML</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Response_SLA_Upcoming_Violation_Email_HML</template>
    </alerts>
    <alerts>
        <fullName>Restore_SLA_Violation_Email_Critical</fullName>
        <description>Restore: SLA Violation Email - Critical</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Product_Alert_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Restore_SLA_Violation_Email_Critical</template>
    </alerts>
    <alerts>
        <fullName>Restore_SLA_Violation_Email_Custom</fullName>
        <ccEmails>Clayton.Benz@imaginecommunications.com</ccEmails>
        <ccEmails>Gregory.Weitz@imaginecommunications.com</ccEmails>
        <ccEmails>Carmel.Meyer@imaginecommunications.com</ccEmails>
        <ccEmails>darcie.laur@imaginecommunications.com</ccEmails>
        <description>Restore: SLA Violation Email - Custom</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Restore_Violation</template>
    </alerts>
    <alerts>
        <fullName>Restore_SLA_Violation_Email_HML</fullName>
        <description>Restore: SLA Violation Email - HML</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Restore_SLA_Violation_Email_HML</template>
    </alerts>
    <alerts>
        <fullName>Restore_Upcoming_SLA_Violation_Email_Critical</fullName>
        <description>Restore: Upcoming SLA Violation Email - Critical</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Restore_SLA_Upcoming_Violation_Email_Critical</template>
    </alerts>
    <alerts>
        <fullName>Restore_Upcoming_SLA_Violation_Email_Custom</fullName>
        <ccEmails>Clayton.Benz@imaginecommunications.com</ccEmails>
        <ccEmails>Gregory.Weitz@imaginecommunications.com</ccEmails>
        <ccEmails>Carmel.Meyer@imaginecommunications.com</ccEmails>
        <ccEmails>darcie.laur@imaginecommunications.com</ccEmails>
        <description>Restore: Upcoming SLA Violation Email - Custom</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Restore_Upcoming</template>
    </alerts>
    <alerts>
        <fullName>Restore_Upcoming_SLA_Violation_Email_HML</fullName>
        <description>Restore: Upcoming SLA Violation Email - HML</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Restore_SLA_Upcoming_Violation_Email_HML</template>
    </alerts>
    <alerts>
        <fullName>TechOps_Queue_Email_Notification</fullName>
        <description>TechOps Queue Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Email_Templates/Queue_Owner_Notification</template>
    </alerts>
    <alerts>
        <fullName>Update_SLA_Violation_Email_Critical</fullName>
        <description>Update: SLA Violation Email - Critical</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Product_Alert_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Update_SLA_Violation_Email_Critical</template>
    </alerts>
    <alerts>
        <fullName>Update_SLA_Violation_Email_Custom</fullName>
        <ccEmails>Clayton.Benz@imaginecommunications.com</ccEmails>
        <ccEmails>Gregory.Weitz@imaginecommunications.com</ccEmails>
        <ccEmails>Carmel.Meyer@imaginecommunications.com</ccEmails>
        <ccEmails>darcie.laur@imaginecommunications.com</ccEmails>
        <description>Update: SLA Violation Email - Custom</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Update_Violation</template>
    </alerts>
    <alerts>
        <fullName>Update_SLA_Violation_Email_HML</fullName>
        <description>Update: SLA Violation Email - HML</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Update_SLA_Violation_Email_HML</template>
    </alerts>
    <alerts>
        <fullName>Update_Upcoming_SLA_Violation_Email_Critical</fullName>
        <description>Update: Upcoming SLA Violation Email - Critical</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Update_Upcoming_SLA_Violation_Email_Critical</template>
    </alerts>
    <alerts>
        <fullName>Update_Upcoming_SLA_Violation_Email_Custom</fullName>
        <ccEmails>Clayton.Benz@imaginecommunications.com</ccEmails>
        <ccEmails>Gregory.Weitz@imaginecommunications.com</ccEmails>
        <ccEmails>Carmel.Meyer@imaginecommunications.com</ccEmails>
        <ccEmails>darcie.laur@imaginecommunications.com</ccEmails>
        <description>Update: Upcoming SLA Violation Email - Custom</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Update_Upcoming</template>
    </alerts>
    <alerts>
        <fullName>Update_Upcoming_SLA_Violation_Email_HML</fullName>
        <description>Update: Upcoming SLA Violation Email - HML</description>
        <protected>false</protected>
        <recipients>
            <field>Case_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SLA_Templates/Update_Upcoming_SLA_Violation_Email_HML</template>
    </alerts>
    <alerts>
        <fullName>Web_to_Case_Created_Notification</fullName>
        <description>Web to Case Created Notification</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@imaginecommunications.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Service_Email_Templates/Receipt_WebToCase</template>
    </alerts>
    <fieldUpdates>
        <fullName>Case_Last_Updated</fullName>
        <description>update the date of the case last updated field</description>
        <field>Case_Last_Updated__c</field>
        <formula>NOW()</formula>
        <name>Case Last Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_record_type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Service_Executive_Escalated</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change record type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_Email_Sent_Checkbox</fullName>
        <field>Closed_Email_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Closed Email Sent Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalated_Closed_Email_Sent</fullName>
        <field>Escalated_Closed_Email_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Escalated Closed Email Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalated_Closed_Email_Sent_Reset</fullName>
        <field>Escalated_Closed_Email_Sent__c</field>
        <literalValue>0</literalValue>
        <name>Escalated Closed Email Sent Reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalation_Update_Resolved_By</fullName>
        <field>Escalated_Marked_Resolved_By__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>Escalation Update Resolved By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalation_Update_Resolved_Date</fullName>
        <field>Escalated_Date_Resolved__c</field>
        <formula>NOW()</formula>
        <name>Escalation Update Resolved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Update_Status_to_Completed</fullName>
        <field>Initial_Update_Milestone_Status__c</field>
        <formula>&quot;Completed&quot;</formula>
        <name>Initial Update Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Update_Status_to_Violation</fullName>
        <field>Initial_Update_Milestone_Status__c</field>
        <formula>&quot;Violation&quot;</formula>
        <name>Initial Update Status to Violation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Case_Owner_Manager_Email</fullName>
        <field>Case_Owner_Manager_Email__c</field>
        <formula>Owner:User.Manager.Email</formula>
        <name>Populate Case Owner Manager Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Alert_Field</fullName>
        <field>Alert__c</field>
        <name>Remove Alert Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Date_Time_Status_Open</fullName>
        <field>Date_Time_Status_Open__c</field>
        <name>Remove Date/Time Status Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Milestone_Notes</fullName>
        <field>Milestone_Exception_Notes__c</field>
        <name>Remove Milestone Notes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Oracle_Order_Numbers</fullName>
        <field>OracleOrderNumbers__c</field>
        <name>Remove Oracle Order Numbers</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Origin</fullName>
        <field>Origin</field>
        <name>Remove Origin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Pending_Ext_Response_Date_Time</fullName>
        <field>Pending_External_Response_Date_Time__c</field>
        <name>Remove Pending Ext Response Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Pending_Int_Response_Date_Time</fullName>
        <field>Pending_Internal_Response_Date_Time__c</field>
        <name>Remove Pending Int Response Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Pending_Parts_Order_Date_Time</fullName>
        <field>Pending_Parts_Order_Date_Time__c</field>
        <name>Remove Pending Parts Order Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Resolution</fullName>
        <field>Resolution__c</field>
        <name>Remove Resolution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Resolution_Comm_to_Customer</fullName>
        <field>Resolution_Communicated_to_Customer__c</field>
        <name>Remove Resolution Comm to Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Resolution_Milestone_Status</fullName>
        <field>Resolution_Milestone_Status__c</field>
        <name>Remove Resolution Milestone Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Resolution_Type</fullName>
        <field>Resolution_Type__c</field>
        <name>Remove Resolution Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Resolved_Date_Time</fullName>
        <field>Resolved_Date_Time__c</field>
        <name>Remove Resolved Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Response_Communicated_to_Customer</fullName>
        <field>Response_Communicated_to_Customer__c</field>
        <name>Remove Response Communicated to Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Response_Milestone_Status</fullName>
        <field>Response_Milestone_Status__c</field>
        <name>Remove Response Milestone Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Restore_Communicated_to_Customer</fullName>
        <field>Restore_Communicated_to_Customer__c</field>
        <name>Remove Restore Communicated to Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Restore_Date_Time</fullName>
        <field>Restore_Date_Time__c</field>
        <name>Remove Restore Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Restore_Milestone_Status</fullName>
        <field>Restore_Milestone_Status__c</field>
        <name>Remove Restore Milestone Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Update_Milestone_Status</fullName>
        <field>Update_Milestone_Status__c</field>
        <name>Remove Update Milestone Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resolution_Communicated_to_Customer</fullName>
        <description>Resolution Communicated to Customer</description>
        <field>Resolution_Communicated_to_Customer__c</field>
        <formula>NOW()</formula>
        <name>Resolution Communicated to Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resolution_Milestone_Status_to_70</fullName>
        <field>Resolution_Milestone_Status__c</field>
        <formula>&quot;70% Reached&quot;</formula>
        <name>Resolution Milestone Status to 70%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resolution_Milestone_Status_to_80</fullName>
        <field>Resolution_Milestone_Status__c</field>
        <formula>&quot;80% Reached&quot;</formula>
        <name>Resolution Milestone Status to 80%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resolution_Milestone_Status_to_90</fullName>
        <field>Resolution_Milestone_Status__c</field>
        <formula>&quot;90% Reached&quot;</formula>
        <name>Resolution Milestone Status to 90%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resolution_Milestone_Status_to_Completed</fullName>
        <field>Resolution_Milestone_Status__c</field>
        <formula>&quot;Completed&quot;</formula>
        <name>Resolution Milestone Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resolution_Milestone_Status_to_Null</fullName>
        <field>Resolution_Milestone_Status__c</field>
        <name>Resolution Milestone Status to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resolution_Milestone_Status_to_Violation</fullName>
        <field>Resolution_Milestone_Status__c</field>
        <formula>&quot;Violation&quot;</formula>
        <name>Resolution Milestone Status to Violation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Response_Communicated_to_Customer</fullName>
        <description>Response Communicated to Customer</description>
        <field>Response_Communicated_to_Customer__c</field>
        <formula>NOW()</formula>
        <name>Response Communicated to Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Response_Milestone_Status_to_70</fullName>
        <field>Response_Milestone_Status__c</field>
        <formula>&quot;70% Reached&quot;</formula>
        <name>Response Milestone Status to 70%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Response_Milestone_Status_to_80</fullName>
        <field>Response_Milestone_Status__c</field>
        <formula>&quot;80% Reached&quot;</formula>
        <name>Response Milestone Status to 80%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Response_Milestone_Status_to_90</fullName>
        <field>Response_Milestone_Status__c</field>
        <formula>&quot;90% Reached&quot;</formula>
        <name>Response Milestone Status to 90%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Response_Milestone_Status_to_Completed</fullName>
        <field>Response_Milestone_Status__c</field>
        <formula>&quot;Completed&quot;</formula>
        <name>Response Milestone Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Response_Milestone_Status_to_Null</fullName>
        <field>Response_Milestone_Status__c</field>
        <name>Response Milestone Status to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Response_Milestone_Status_to_Violation</fullName>
        <field>Response_Milestone_Status__c</field>
        <formula>&quot;Violation&quot;</formula>
        <name>Response Milestone Status to Violation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Restore_Communicated_to_Customer</fullName>
        <field>Restore_Communicated_to_Customer__c</field>
        <formula>NOW()</formula>
        <name>Restore Communicated to Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Restore_Milestone_Status_to_70</fullName>
        <field>Restore_Milestone_Status__c</field>
        <formula>&quot;70% Reached&quot;</formula>
        <name>Restore Milestone Status to 70%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Restore_Milestone_Status_to_80</fullName>
        <field>Restore_Milestone_Status__c</field>
        <formula>&quot;80% Reached&quot;</formula>
        <name>Restore Milestone Status to 80%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Restore_Milestone_Status_to_90</fullName>
        <field>Restore_Milestone_Status__c</field>
        <formula>&quot;90% Reached&quot;</formula>
        <name>Restore Milestone Status to 90%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Restore_Milestone_Status_to_Completed</fullName>
        <field>Restore_Milestone_Status__c</field>
        <formula>&quot;Completed&quot;</formula>
        <name>Restore Milestone Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Restore_Milestone_Status_to_Null</fullName>
        <field>Restore_Milestone_Status__c</field>
        <name>Restore Milestone Status to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Restore_Milestone_Status_to_Violation</fullName>
        <field>Restore_Milestone_Status__c</field>
        <formula>&quot;Violation&quot;</formula>
        <name>Restore Milestone Status to Violation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Default_Impact</fullName>
        <description>used with web 2 case</description>
        <field>Impact__c</field>
        <literalValue>Medium</literalValue>
        <name>Service: Default Impact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Default_Urgency</fullName>
        <field>Urgency__c</field>
        <literalValue>Medium</literalValue>
        <name>Service: Default Urgency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Reported_Version_Update</fullName>
        <description>Service: Reported Version Update</description>
        <field>Reported_Version__c</field>
        <formula>Current_Version__c</formula>
        <name>Service: Reported Version Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Update_Restore_Communicated_to</fullName>
        <field>Restore_Communicated_to_Customer__c</field>
        <formula>NOW()</formula>
        <name>Service: Update Restore Communicated to</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Update_Restore_Date_Time</fullName>
        <field>Restore_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Service: Update Restore Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Date_of_Escalation</fullName>
        <field>Date_of_Escalation__c</field>
        <formula>NOW()</formula>
        <name>Set Date of Escalation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Escalated_By</fullName>
        <field>Escalated_Escalated_By__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>Set Escalated By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Escalated_Date</fullName>
        <field>Escalated_Escalated_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Escalated Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Stopped_Field</fullName>
        <field>IsStopped</field>
        <literalValue>0</literalValue>
        <name>Uncheck Stopped Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Age_Modifier</fullName>
        <field>Age_Modifier_for_IOI__c</field>
        <literalValue>1</literalValue>
        <name>Update Age Modifier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Alert_to_Violation</fullName>
        <field>Alert__c</field>
        <formula>&quot;Violation&quot;</formula>
        <name>Update Alert to Violation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Alert_to_Warning</fullName>
        <field>Alert__c</field>
        <formula>&quot;Warning&quot;</formula>
        <name>Update Alert to Warning</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Alt_Email</fullName>
        <field>Alternate_Email__c</field>
        <formula>SuppliedEmail</formula>
        <name>Update Alt Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Origin_to_Community</fullName>
        <field>Origin</field>
        <literalValue>Community</literalValue>
        <name>Update Case Origin to Community</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Type</fullName>
        <field>Type</field>
        <literalValue>General Inquiry</literalValue>
        <name>Update Case Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Custom_SLA_on_Case</fullName>
        <field>Custom_SLA__c</field>
        <literalValue>1</literalValue>
        <name>Update Custom SLA on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Description</fullName>
        <field>Description_2__c</field>
        <formula>Description</formula>
        <name>Update Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Milestone_Status_to_70</fullName>
        <field>Update_Milestone_Status__c</field>
        <formula>&quot;70% Reached&quot;</formula>
        <name>Update Milestone Status to 70%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Milestone_Status_to_80</fullName>
        <field>Update_Milestone_Status__c</field>
        <formula>&quot;80% Reached&quot;</formula>
        <name>Update Milestone Status to 80%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Milestone_Status_to_90</fullName>
        <field>Update_Milestone_Status__c</field>
        <formula>&quot;90% Reached&quot;</formula>
        <name>Update Milestone Status to 90%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Milestone_Status_to_Blank</fullName>
        <field>Update_Milestone_Status__c</field>
        <name>Update Milestone Status to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Milestone_Status_to_Completed</fullName>
        <field>Update_Milestone_Status__c</field>
        <formula>&quot;Completed&quot;</formula>
        <name>Update Milestone Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Milestone_Status_to_Violation</fullName>
        <field>Update_Milestone_Status__c</field>
        <formula>&quot;Violation&quot;</formula>
        <name>Update Milestone Status to Violation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pending_External_Response_to_Fals</fullName>
        <description>Update Pending External Response checkbox to false when status is not in Pending External Response.</description>
        <field>Pending_External_Response__c</field>
        <literalValue>0</literalValue>
        <name>Update Pending External Response to Fals</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pending_External_Response_to_True</fullName>
        <field>Pending_External_Response__c</field>
        <literalValue>1</literalValue>
        <name>Update Pending External Response to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Priority_to_Critical</fullName>
        <field>Priority</field>
        <literalValue>1-Critical</literalValue>
        <name>Update Priority to Critical</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Priority_to_High</fullName>
        <field>Priority</field>
        <literalValue>2-High</literalValue>
        <name>Update Priority to High</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Priority_to_Low</fullName>
        <field>Priority</field>
        <literalValue>4-Low</literalValue>
        <name>Update Priority to Low</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Priority_to_Medium</fullName>
        <field>Priority</field>
        <literalValue>3-Medium</literalValue>
        <name>Update Priority to Medium</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Category</fullName>
        <field>Product_Category__c</field>
        <literalValue>Eclipse Web</literalValue>
        <name>Update Product Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Family</fullName>
        <field>Product_Line__c</field>
        <literalValue>Media Software</literalValue>
        <name>Update Product Family</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Line</fullName>
        <field>Product_Family__c</field>
        <literalValue>Eclipse Plus</literalValue>
        <name>Update Product Line</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Change_Email_to_Blank</fullName>
        <field>Status_Change_Email__c</field>
        <name>Update Status Change Email to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Change_Email_to_Now</fullName>
        <field>Status_Change_Email__c</field>
        <formula>NOW()</formula>
        <name>Update Status Change Email to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updated_Executive_Escalated_Updated_By</fullName>
        <field>Escalated_Last_Updated_By__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>Updated Executive Escalated Updated By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updated_Executive_Escalated_Updated_Date</fullName>
        <field>Escalated_Date_of_Last_Update__c</field>
        <formula>NOW()</formula>
        <name>Updated Executive Escalated Updated Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Weighting_Last_Updated</fullName>
        <field>Weighting_Last_Updated__c</field>
        <formula>NOW()</formula>
        <name>Weighting Last Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Weighting_Last_Updated_By</fullName>
        <field>Weighting_Last_Updated_By__c</field>
        <formula>$User.Full_Name__c</formula>
        <name>Weighting Last Updated By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Weighting_Last_Updated_Process</fullName>
        <field>Weighting_Last_Updated_Process__c</field>
        <formula>&quot;Case Age&quot;</formula>
        <name>Weighting Last Updated Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X30_Day_Status_Update</fullName>
        <description>30 Days after Rule Trigger Date, change Status to “Closed” and send email to Contact and Alternate Email address on case.  Include link to survey in the email template.</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>30 Day Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X50_Resolution_Update_with_No_Owner</fullName>
        <description>Update “Resolution Milestone Status” with value in “Resolution 50%” + “No Owner”</description>
        <field>Resolution_Milestone_Status__c</field>
        <formula>IF( 
(ISBLANK( Owner:User.Id )), 
(&quot;50% Reached No Owner&quot;), 
(&quot; &quot;) 
)</formula>
        <name>50% Resolution Update with No Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X50_Response_Update_with_No_Owner</fullName>
        <field>Response_Milestone_Status__c</field>
        <formula>IF(
 (ISBLANK( Owner:User.Id )),
(&quot;50% Reached No Owner&quot;),
(&quot; &quot;)
)</formula>
        <name>50% Response Update with No Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X50_Restore_Update_with_No_Owner</fullName>
        <description>Update “Restore Milestone Status” with value in “Restore 50%” + “No Owner”</description>
        <field>Restore_Milestone_Status__c</field>
        <formula>IF( 
(ISBLANK( Owner:User.Id )), 
(&quot;50% Reached No Owner&quot;), 
(&quot; &quot;) 
)</formula>
        <name>50% Restore Update with No Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X50_Update_Update_with_No_Owner</fullName>
        <description>Update “Update Milestone Status” with value in “Update 50%” + “No Owner”</description>
        <field>Update_Milestone_Status__c</field>
        <formula>IF( 
(ISBLANK( Owner:User.Id )), 
(&quot;50% Reached No Owner&quot;), 
(&quot; &quot;) 
)</formula>
        <name>50% Update Update with No Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Case Last Updated</fullName>
        <actions>
            <name>Case_Last_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Profile_Name__c</field>
            <operation>notEqual</operation>
            <value>System Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Profile_Name__c</field>
            <operation>notEqual</operation>
            <value>Imagine - API User</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case%3A Tech Ops copy Email to Alt Email</fullName>
        <actions>
            <name>Update_Alt_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Product_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Product_Family</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Product_Line</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(	OwnerId=&quot;00G31000004y3Vn&quot;,
				 TEXT(Origin) = &quot;Email&quot;,
				 CreatedById = &quot;005i0000004LaIyAAK&quot;
			)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Change Status to Closed after Pending External Response for 30 Days and Send Email %28Without Survey%29 to Contact</fullName>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 6 AND 7 AND (4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Service,Service_Escalated,Service Executive Escalated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Pending External Response</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Pending_External_Response__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Historical_Publish_External__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>3rd Party</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Historical_SR_Number__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Go_Live_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Closed_Notification_Without_Survey</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>X30_Day_Status_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Automated_Email_Sent_to_Contact_and_Alternate_Email_on_Case_Closure_after_30_Day</name>
                <type>Task</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Service%3A Change Status to Closed after Pending External Response for 30 Days and Send Email to Contact</fullName>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Service,Service_Escalated,Service Executive Escalated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Pending External Response</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Pending_External_Response__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Historical_Publish_External__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>notEqual</operation>
            <value>3rd Party</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Historical_SR_Number__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Go_Live_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Closed_Notification</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>X30_Day_Status_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Automated_Email_Sent_to_Contact_and_Alternate_Email_on_Case_Closure_after_30_Day</name>
                <type>Task</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Service%3A Change layout if escalated</fullName>
        <actions>
            <name>Set_Escalated_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Escalated_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Escalation_Manager_Escalation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>DEPRECIATED - replaced by weighting</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Change layout if executive escalated</fullName>
        <actions>
            <name>Change_record_type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Date_of_Escalation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Escalated_Executive_Escalation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Clear Case Status fields from Parent Case</fullName>
        <actions>
            <name>Remove_Alert_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Date_Time_Status_Open</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Oracle_Order_Numbers</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Pending_Ext_Response_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Pending_Int_Response_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Pending_Parts_Order_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Resolution</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Resolution_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Resolved_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Restore_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.ParentId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Clear Case fields from Parent Case</fullName>
        <actions>
            <name>Remove_Milestone_Notes</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Resolution_Comm_to_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Resolution_Milestone_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Response_Communicated_to_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Response_Milestone_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Restore_Communicated_to_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Restore_Milestone_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Update_Milestone_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.ParentId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Custom SLA Update</fullName>
        <actions>
            <name>Update_Custom_SLA_on_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Custom_SLA__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>updates the custom sla checkbox on the case view from the matching one on the account</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Email-to-Case Description Update</fullName>
        <actions>
            <name>Update_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email,Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update the custom description field with the standard description contents when the case is created through email-to-case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Pending External Response %3D False</fullName>
        <actions>
            <name>Update_Pending_External_Response_to_Fals</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status_Detail__c</field>
            <operation>notEqual</operation>
            <value>Pending External Response</value>
        </criteriaItems>
        <description>When status ischanged &amp; Previous value is &apos;Pending External Response&apos;, make &apos;Pending External Response&apos; = False</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Pending External Response %3D True</fullName>
        <actions>
            <name>Update_Pending_External_Response_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Record_Type__c</field>
            <operation>equals</operation>
            <value>Service,Service_Escalated,Service Executive Escalated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status_Detail__c</field>
            <operation>equals</operation>
            <value>Pending External Response</value>
        </criteriaItems>
        <description>Update the Pending External Response checkbox to true when Status changes to Pending External Response</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Populate Case Owner Manager Field</fullName>
        <actions>
            <name>Populate_Case_Owner_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This field populates the Case Owner Manager Email field on the case record</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Reported Version default to Current Version</fullName>
        <actions>
            <name>Service_Reported_Version_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Reported_Version__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Current_Version__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Service: Reported Version default to Current Version</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Resolution Communicated to Customer</fullName>
        <actions>
            <name>Resolution_Communicated_to_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Resolved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Resolution_Communicated_to_Customer__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Service: Resolution Communicated to Customer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Response Communicated to Customer</fullName>
        <actions>
            <name>Response_Communicated_to_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Response_Communicated_to_Customer__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Service: Response Communicated to Customer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Restore Communicated to Customer</fullName>
        <actions>
            <name>Restore_Communicated_to_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Restore</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Restore_Communicated_to_Customer__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Service: Restore Communicated to Customer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Send Email to Contact When Status Changes</fullName>
        <actions>
            <name>Case_Status_Change_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Status_Change_Email_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Automated_Email_Sent_to_Contact_and_Alternate_Email_on_Status_Change</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>(  Contact.Do_Not_Email__c &amp;&amp; Go_Live_Date__c &lt;= TODAY() ) &amp;&amp; (RecordType.Name = &quot;Service&quot;) &amp;&amp;  ( ISPICKVAL(PRIORVALUE(Status), &quot;New&quot;) &amp;&amp; (ISPICKVAL(Status, &quot;Open&quot;))) ||  ((ISCHANGED(Status))&amp;&amp;(ISPICKVAL (PRIORVALUE(Status),&quot;Pending External Response&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Send Email to Contact on Case Creation</fullName>
        <actions>
            <name>Case_Creation_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Automated_Email_Sent_to_Contact_and_Alternate_Email_on_Case_Creation</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 5 AND (4 OR 6) AND 7</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notContain</operation>
            <value>imaginecommunications.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notContain</operation>
            <value>IMAGINE COMMUNICATIONS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Undeliverable:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Do_Not_Email__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Out of the Office</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Web</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Send Email to Contact on Case Creation Web2Case</fullName>
        <actions>
            <name>Web_to_Case_Created_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Service_Default_Impact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Service_Default_Urgency</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 5 AND (4 OR 6) AND 7</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notContain</operation>
            <value>imaginecommunications.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notContain</operation>
            <value>IMAGINE COMMUNICATIONS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Undeliverable:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Do_Not_Email__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Out of the Office</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <description>web to case version of autoresponse.  tried the case autoresponse rules but you can&apos;t set the from address???  WHY!</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Send Email to Contact when Case is Closed</fullName>
        <actions>
            <name>Case_Closure</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Closed_Email_Sent_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Automated_Email_Sent_to_Contact_and_Alternate_Email_on_Case_Closure</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Days_Pending_External_Response__c</field>
            <operation>lessThan</operation>
            <value>30</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>notEqual</operation>
            <value>3rd Party</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Time_Since_Closed__c</field>
            <operation>lessOrEqual</operation>
            <value>360</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Go_Live_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Profile_Name__c</field>
            <operation>notEqual</operation>
            <value>System Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Closed_Email_Sent__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Do_Not_Email__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Send Email to Contact when Case is Closed %28No survey%29</fullName>
        <actions>
            <name>Case_Closure_Without_Survey</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Closed_Email_Sent_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Automated_Email_Sent_to_Contact_and_Alternate_Email_on_Case_Closure</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Days_Pending_External_Response__c</field>
            <operation>lessThan</operation>
            <value>30</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>3rd Party</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Do_Not_Email__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Ignore_Automation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Profile_Name__c</field>
            <operation>notEqual</operation>
            <value>System Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Closed_Email_Sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Service%3A Send Email to Contact when Status is Pending External Response after 15 Days</fullName>
        <actions>
            <name>Case_Status_of_Pending_External_Response_for_15_Days_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Automated_Email_Sent_to_Contact_and_Alternate_Email_after_15_Days_in_Pending_Ext</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Service,Service_Escalated,Service Executive Escalated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Pending External Response</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Days_Pending_External_Response__c</field>
            <operation>equals</operation>
            <value>15</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Historical_SR_Number__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Go_Live_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Pending_External_Response__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Send Email to Contact when Type is Enhancement</fullName>
        <actions>
            <name>Case_Enhancement_Type_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Automated_Email_Sent_to_Contact_and_Alternate_Email_on_Case_Type_Enhancement</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Enhancement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Go_Live_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>disabled 12/2/2015 at the request of Clayton</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Send Email to Product Alert Email on Critical Case Closed</fullName>
        <actions>
            <name>Critical_Case_Closed_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Escalated_Closed_Email_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(NOT(ISNEW()), OR (RecordType.Name = &apos;Service&apos;,RecordType.Name =  &apos;Service_Escalated&apos;, RecordType.Name = &apos;Service Executive Escalated&apos;),  TEXT(Priority) = &apos;1-Critical&apos;,    Status_Closed__c   = true,  Escalated_Closed_Email_Sent__c = false )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Send Email to Product Alert Email on Critical Case Creation</fullName>
        <actions>
            <name>Critical_Case_Creation_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_was_sent_to_Service_Managers_that_a_Critical_Case_was_Created</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>OR (
AND (ISNEW(), ISPICKVAL(Priority, &quot;1-Critical&quot;)),
AND (ISCHANGED(Priority), ISPICKVAL(Priority, &quot;1-Critical&quot;))
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Send Email to Product Alert Email on Critical Case Update</fullName>
        <actions>
            <name>Critical_Case_Update_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Escalated_Closed_Email_Sent_Reset</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(NOT(ISNEW()), TEXT(Priority) = &apos;1-Critical&apos;,   Status_Closed__c   = false )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Set resolved fields for Escalated Case</fullName>
        <actions>
            <name>Escalation_Update_Resolved_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Escalation_Update_Resolved_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Escalated_Escalation_Resolved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When resolved checkbox is checked update the resolved by and date fields</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Set updated fields for Executive Escalated case</fullName>
        <actions>
            <name>Updated_Executive_Escalated_Updated_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Updated_Executive_Escalated_Updated_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Set updated date and by fields for executive escalated cases</description>
        <formula>OR( 
ISNEW(), 
AND( 
NOT(ISNEW()), 
Escalated_Executive_Escalation__c = TRUE, 
ISCHANGED( Escalated_Last_Action__c) 
) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A TechOps Queue Assignment Email</fullName>
        <actions>
            <name>TechOps_Queue_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Service: TechOps Queue Assignment Email</description>
        <formula>(ISCHANGED(OwnerId) &amp;&amp; OwnerId=&quot;00G31000004y3Vn&quot;) ||
(ISNEW() &amp;&amp; OwnerId=&quot;00G31000004y3Vn&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Update Case Origin When Created by Community Users</fullName>
        <actions>
            <name>Update_Case_Origin_to_Community</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2 or 3</booleanFilter>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>contains</operation>
            <value>Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>contains</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>contains</operation>
            <value>Community</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Update Priority to Critical</fullName>
        <actions>
            <name>Update_Priority_to_Critical</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Community User Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Impact__c</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Urgency__c</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Update Priority to High</fullName>
        <actions>
            <name>Update_Priority_to_High</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( AND(ISPICKVAL(Impact__c, &quot;Medium&quot;), ISPICKVAL(Urgency__c, &quot;High&quot;)), AND(ISPICKVAL(Impact__c, &quot;High&quot;), ISPICKVAL(Urgency__c, &quot;Medium&quot;)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Update Priority to Low</fullName>
        <actions>
            <name>Update_Priority_to_Low</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Impact__c</field>
            <operation>equals</operation>
            <value>Low</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Urgency__c</field>
            <operation>equals</operation>
            <value>Low</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Community User Approval</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Update Priority to Medium</fullName>
        <actions>
            <name>Update_Priority_to_Medium</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( AND(ISPICKVAL(Impact__c, &quot;Medium&quot;), ISPICKVAL(Urgency__c, &quot;Low&quot;)), AND(ISPICKVAL(Impact__c, &quot;High&quot;), ISPICKVAL(Urgency__c, &quot;Low&quot;)), AND(ISPICKVAL(Impact__c, &quot;Low&quot;), ISPICKVAL(Urgency__c, &quot;Medium&quot;)), AND(ISPICKVAL(Impact__c, &quot;Medium&quot;), ISPICKVAL(Urgency__c, &quot;Medium&quot;)), AND(ISPICKVAL(Impact__c, &quot;Low&quot;), ISPICKVAL(Urgency__c, &quot;High&quot;)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service%3A Update Stopped Field to Unchecked</fullName>
        <actions>
            <name>Uncheck_Stopped_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New,Open,Pending Internal Response,Pending Parts Order,Restore</value>
        </criteriaItems>
        <description>When a case status changes from pending external response, resolved, closed, cancelled back to Open, Pending Internal Response or Pending Parts Order, then the &apos;Stopped&apos; checkbox will be unchecked so the SLA will start again.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update IOI Case Age when Needs Update is True</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Needs_Update_TEMPORARY__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Product_Line__c</field>
            <operation>notEqual</operation>
            <value>Media Software</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Age_Modifier</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Weighting_Last_Updated</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Weighting_Last_Updated_By</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Weighting_Last_Updated_Process</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Automated_Email_Sent_to_Contact_and_Alternate_Email_after_15_Days_in_Pending_Ext</fullName>
        <assignedToType>creator</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Automated Email Sent to Contact and Alternate Email after 15 Days in Pending External Response</subject>
    </tasks>
    <tasks>
        <fullName>Automated_Email_Sent_to_Contact_and_Alternate_Email_on_Case_Closure</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Automated Email Sent to Contact and Alternate Email on Case Closure</subject>
    </tasks>
    <tasks>
        <fullName>Automated_Email_Sent_to_Contact_and_Alternate_Email_on_Case_Closure_after_30_Day</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Automated Email Sent to Contact and Alternate Email on Case Closure after 30 Days in Pending External Response</subject>
    </tasks>
    <tasks>
        <fullName>Automated_Email_Sent_to_Contact_and_Alternate_Email_on_Case_Creation</fullName>
        <assignedToType>creator</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Automated Email Sent to Contact and Alternate Email on Case Creation</subject>
    </tasks>
    <tasks>
        <fullName>Automated_Email_Sent_to_Contact_and_Alternate_Email_on_Case_Type_Enhancement</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Automated Email Sent to Contact and Alternate Email on Case Type Enhancement</subject>
    </tasks>
    <tasks>
        <fullName>Automated_Email_Sent_to_Contact_and_Alternate_Email_on_Status_Change</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Automated Email Sent to Contact and Alternate Email on Status Change</subject>
    </tasks>
    <tasks>
        <fullName>Email_was_sent_to_Service_Managers_that_a_Critical_Case_was_Created</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email was sent to Service Managers that a Critical Case was Created</subject>
    </tasks>
</Workflow>
