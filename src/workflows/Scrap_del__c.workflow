<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ApprovalEmail</fullName>
        <description>Approval Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/BatteryScrapRequestApproved</template>
    </alerts>
    <alerts>
        <fullName>Approval_Email</fullName>
        <description>Approval Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/BatteryScrapRequestApproved</template>
    </alerts>
    <alerts>
        <fullName>EmailtheScrapAmountDetails</fullName>
        <ccEmails>apyadav@su-kam.com</ccEmails>
        <description>Email the Scrap Amount Details</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Scrap_Amount_Details</template>
    </alerts>
    <alerts>
        <fullName>OtherScrapApprovalEmail</fullName>
        <description>Other Scrap Approval Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/ComponentProductScrapRequestApproved</template>
    </alerts>
    <alerts>
        <fullName>OtherScrapRejectionemail</fullName>
        <description>Other Scrap Rejection email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/ComponentProductScrapRequestRejected</template>
    </alerts>
    <alerts>
        <fullName>RequestRejected</fullName>
        <description>Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/BatteryScrapRequestRejected</template>
    </alerts>
    <alerts>
        <fullName>Request_Rejected</fullName>
        <description>Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/BatteryScrapRequestRejected</template>
    </alerts>
    <alerts>
        <fullName>ScrapSaleEmail</fullName>
        <ccEmails>sukamadmin@su-kam.com</ccEmails>
        <description>Scrap Sale Email</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Scrap_Amount_Details</template>
    </alerts>
    <alerts>
        <fullName>Scrap_Sale_Email</fullName>
        <ccEmails>sukamadmin@su-kam.com</ccEmails>
        <description>Scrap Sale Email</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Scrap_Amount_Details</template>
    </alerts>
    <fieldUpdates>
        <fullName>ChangeLayout</fullName>
        <field>RecordTypeId</field>
        <lookupValue>After_Approval_Scrap</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Layout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Layout</fullName>
        <field>RecordTypeId</field>
        <lookupValue>After_Approval_Scrap</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Layout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LockLayout</fullName>
        <field>RecordTypeId</field>
        <lookupValue>After_Approval_Scrap</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lock Layout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lock_Layout</fullName>
        <field>RecordTypeId</field>
        <lookupValue>After_Approval_Scrap</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lock Layout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ScrapSaleApproved</fullName>
        <field>Scrap_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Scrap Sale Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ScrapSaleRejected</fullName>
        <field>Scrap_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Scrap Sale Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Scrap_Sale_Approved</fullName>
        <field>Scrap_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Scrap Sale Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Scrap_Sale_Approved1</fullName>
        <field>Scrap_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Scrap Sale Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Scrap_Sale_Rejected</fullName>
        <field>Scrap_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Scrap Sale Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Scrap Sale Details</fullName>
        <actions>
            <name>ScrapSaleEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Scrap_del__c.Type_of_Scrap__c</field>
            <operation>equals</operation>
            <value>Battery Scrap</value>
        </criteriaItems>
        <criteriaItems>
            <field>Scrap_del__c.Scrap_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
