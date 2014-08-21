<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SendEmailforEnquiry</fullName>
        <ccEmails>mamta@su-kam.com</ccEmails>
        <description>Send Email for Enquiry</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/NewEnquirynotification</template>
    </alerts>
    <fieldUpdates>
        <fullName>UpdateEnquiryStatus</fullName>
        <field>Status</field>
        <literalValue>Contacted</literalValue>
        <name>Update Enquiry Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Send an Enquiry Email</fullName>
        <actions>
            <name>SendEmailforEnquiry</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>UpdateEnquiryStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.LastName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
