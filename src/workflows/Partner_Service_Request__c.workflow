<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Escalation_Mail_10_days_in_case_Complaints</fullName>
        <ccEmails>chetna@su-kam.com</ccEmails>
        <description>Escalation Mail (10 days) in case Complaints</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Escalation_Mail_10_days_in_case_Complaints</template>
    </alerts>
    <alerts>
        <fullName>Escalation_Mail_10_days_in_case_Product_Complaints</fullName>
        <ccEmails>customercare@su-kam.com</ccEmails>
        <description>Escalation Mail (10 days) in case Product Complaints</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Escalation_Mail_10_days_in_case_Complaints</template>
    </alerts>
    <alerts>
        <fullName>Escalation_Mail_30_days_in_case_of_Dealer_Cetificate_service_Request_is_not_atte</fullName>
        <ccEmails>chetna@su-kam.com</ccEmails>
        <description>Escalation Mail (30 days) in case of Dealer Cetificate service Request is not attended to</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Escalation_Mail_30_days_in_case_of_Dealer_Cetificate_service_Request_is_not_at</template>
    </alerts>
    <alerts>
        <fullName>Escalation_Mail_45_days_in_case_of_Boards_service_Request_is_not_attended_to</fullName>
        <ccEmails>chetna@su-kam.com</ccEmails>
        <description>Escalation Mail (45 days) in case of Boards service Request is not attended to</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Escalation_Mail_45_days_in_case_of_Boards_service_Request_is_not_attended_to</template>
    </alerts>
    <alerts>
        <fullName>Escalation_Mail_5_days_in_case_Complaints_are_not_attended_to</fullName>
        <ccEmails>kmishra@su-kam.com</ccEmails>
        <description>Escalation Mail (5 days) in case Complaints are not attended to</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Escalation_Mail_5_days_in_case_Complaints_are_not_attended_to</template>
    </alerts>
    <alerts>
        <fullName>Escalation_Mail_7_days_in_case_of_PoP_service_Request_is_not_attended_to</fullName>
        <ccEmails>chetna@su-kam.com</ccEmails>
        <description>Escalation Mail (7 days) in case of PoP service Request is not attended to</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Escalation_Mail_7_days_in_case_of_PoP_service_Request_is_not_attended_to</template>
    </alerts>
    <alerts>
        <fullName>Financial_Requests_acknowledgment_Mail</fullName>
        <description>Financial Requests acknowledgment Mail</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Financial_Requests_acknowledgment_Mail</template>
    </alerts>
    <alerts>
        <fullName>Financial_Requests_closeur_Mail</fullName>
        <description>Financial Requests closeur Mail</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Financial_Requests_closeur_Mail</template>
    </alerts>
    <alerts>
        <fullName>General_Request_Closed</fullName>
        <description>General Request Closed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/when_the_complaint_is_closed</template>
    </alerts>
    <alerts>
        <fullName>MM_Mail_sent_to_distributor_when_the_service_request_is_closed</fullName>
        <description>MM Mail sent to distributor when the service request is closed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Mail_sent_to_distributor_when_the_Financial_request_is_closed</template>
    </alerts>
    <alerts>
        <fullName>MM_Request_Mail_to_be_sent_to_distributor_acknowledging_service_request</fullName>
        <description>MM Request Mail to be sent to distributor acknowledging service request</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Mail_to_be_sent_to_distributor_acknowledging_service_request</template>
    </alerts>
    <alerts>
        <fullName>Mail_to_be_sent_to_Customer_Care</fullName>
        <ccEmails>customercare@su-kam.com</ccEmails>
        <description>Mail to be sent to Customer Care</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Mail_to_be_sent_to_Marketing_Manager</template>
    </alerts>
    <alerts>
        <fullName>Mail_to_be_sent_to_Marketing_Manager</fullName>
        <description>Mail to be sent to Marketing Manager</description>
        <protected>false</protected>
        <recipients>
            <recipient>sc.kanpur@su-kam.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Mail_to_be_sent_to_Marketing_Manager</template>
    </alerts>
    <alerts>
        <fullName>Mail_to_be_sent_to_Marketing_Manager_Chetna_Sundaram</fullName>
        <description>Mail to be sent to Marketing Manager (Chetna Sundaram)</description>
        <protected>false</protected>
        <recipients>
            <recipient>sc.kanpur@su-kam.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/Mail_to_be_sent_to_Marketing_Manager</template>
    </alerts>
    <alerts>
        <fullName>Mail_to_be_sent_to_distributor_acknowledging_service_request</fullName>
        <description>Mail to be sent to distributor acknowledging service request</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/distributor_acknowledging_service_request</template>
    </alerts>
    <alerts>
        <fullName>distributor_when_the_complaint_is_closed</fullName>
        <description>distributor when the complaint is closed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sukam_Templates/when_the_complaint_is_closed</template>
    </alerts>
    <fieldUpdates>
        <fullName>Closed_General_Complaint_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Closed_General_Complaints</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Closed General Complaint Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_MM_Request</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Closed_Marketing_Material_Request</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Closed MM Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Financial_Closed_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Closed_Financial</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Financial Closed Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Complaint_Closed_Layout</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Closed_Product_Complaints</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Product Complaint Closed Layout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email TO Distributor General Complaints</fullName>
        <actions>
            <name>Mail_to_be_sent_to_Marketing_Manager</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Mail_to_be_sent_to_distributor_acknowledging_service_request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>General Information / Complaints</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email TO Distributor Product Complaint</fullName>
        <actions>
            <name>Mail_to_be_sent_to_Customer_Care</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Product Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Escalation Mail %2830 days%29 in case of Dealer Cetificate service Request is not attended to</fullName>
        <actions>
            <name>Escalation_Mail_30_days_in_case_of_Dealer_Cetificate_service_Request_is_not_atte</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Marketing Material Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Type_Of_Request__c</field>
            <operation>equals</operation>
            <value>Dealer Certificates</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Escalation Mail %2845 days%29 in case of Boards service Request is not attended to</fullName>
        <actions>
            <name>Escalation_Mail_45_days_in_case_of_Boards_service_Request_is_not_attended_to</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Marketing Material Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Type_Of_Request__c</field>
            <operation>equals</operation>
            <value>Others</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Escalation Mail %287 days%29 in case of PoP service Request is not attended to</fullName>
        <actions>
            <name>Escalation_Mail_7_days_in_case_of_PoP_service_Request_is_not_attended_to</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Marketing Material Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Type_Of_Request__c</field>
            <operation>notEqual</operation>
            <value>Dealer Certificates,Boards</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Email TO Distributor</fullName>
        <actions>
            <name>Financial_Requests_acknowledgment_Mail</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Financial Service Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Financial Esclation Mail</fullName>
        <actions>
            <name>Escalation_Mail_5_days_in_case_Complaints_are_not_attended_to</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.Esclation_Date_5_days__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Financial Request Closed Layout</fullName>
        <actions>
            <name>Financial_Requests_closeur_Mail</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Financial_Closed_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Financial Service Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Executed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>General Complaint Closed Layout</fullName>
        <actions>
            <name>General_Request_Closed</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Closed_General_Complaint_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>General Information / Complaints</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Executed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>General Complaint Esclation Mail</fullName>
        <actions>
            <name>Escalation_Mail_10_days_in_case_Complaints</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.Esclation_Date__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>General Information / Complaints</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MM to be sent to distributor acknowledging service request</fullName>
        <actions>
            <name>MM_Request_Mail_to_be_sent_to_distributor_acknowledging_service_request</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Mail_to_be_sent_to_Marketing_Manager_Chetna_Sundaram</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Marketing Material Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mail to Distributon on Case closure</fullName>
        <actions>
            <name>distributor_when_the_complaint_is_closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Product Complaint,General Information / Complaints</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Executed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Marketing Material Request Closed Layout</fullName>
        <actions>
            <name>MM_Mail_sent_to_distributor_when_the_service_request_is_closed</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Closed_MM_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Marketing Material Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Executed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Product Complaint Closed Layout</fullName>
        <actions>
            <name>Product_Complaint_Closed_Layout</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Product Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Executed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Product Complaint Esclation Mail</fullName>
        <actions>
            <name>Escalation_Mail_10_days_in_case_Product_Complaints</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Partner_Service_Request__c.Esclation_Date__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Partner_Service_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Product Complaint</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
