<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Employee_Engagement_New_Record</fullName>
        <description>Employee Engagement New Record</description>
        <protected>false</protected>
        <recipients>
            <recipient>samit.mitra@su-kam.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Employee_Engagement_new_record</template>
    </alerts>
    <rules>
        <fullName>Employee Engagement new record</fullName>
        <actions>
            <name>Employee_Engagement_New_Record</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Employee_Engagement__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
