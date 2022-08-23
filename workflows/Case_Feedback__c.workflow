<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_email_on_Case_Feedback_Creation</fullName>
        <description>Send email on Case Feedback Creation</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Service_Email_Templates/Case_Feedback_Received</template>
    </alerts>
</Workflow>
