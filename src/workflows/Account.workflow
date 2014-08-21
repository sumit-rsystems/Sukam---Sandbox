<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateCustomerId</fullName>
        <field>Customer_ID__c</field>
        <formula>IF (( MONTH(TODAY() ) &gt;= 4 ) &amp;&amp; (DAY(TODAY()) &gt;= 1 ) , 

&apos;CIN-&apos;+RIGHT(TEXT(YEAR(TODAY()) + 1 ),2) + 

CASE(TEXT(MONTH(TODAY())),&quot;1&quot;,&quot;01&quot;,

&quot;2&quot;,&quot;02&quot;, 

&quot;3&quot;,&quot;03&quot;, 

&quot;4&quot;,&quot;04&quot;, 

&quot;5&quot;,&quot;05&quot;, 

&quot;6&quot;,&quot;06&quot;, 

&quot;7&quot;,&quot;07&quot;, 

&quot;8&quot;,&quot;08&quot;, 

&quot;9&quot;,&quot;09&quot;, 

TEXT(MONTH(TODAY()))) + Cust_No__c , 

&apos;CIN-&apos;+RIGHT(TEXT(YEAR(TODAY())),2) + 

CASE(TEXT(MONTH(TODAY())),&quot;1&quot;,&quot;01&quot;,

&quot;2&quot;,&quot;02&quot;, 

&quot;3&quot;,&quot;03&quot;, 

&quot;4&quot;,&quot;04&quot;, 

&quot;5&quot;,&quot;05&quot;, 

&quot;6&quot;,&quot;06&quot;, 

&quot;7&quot;,&quot;07&quot;, 

&quot;8&quot;,&quot;08&quot;, 

&quot;9&quot;,&quot;09&quot;,

TEXT(MONTH(TODAY()))) + Cust_No__c )</formula>
        <name>Update Customer Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Country</fullName>
        <field>BillingCountry</field>
        <formula>Country__c</formula>
        <name>Update Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pin_Code</fullName>
        <field>BillingPostalCode</field>
        <formula>Pin_Code__c</formula>
        <name>Update Pin Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Detail_Page</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_billing_street</fullName>
        <field>BillingStreet</field>
        <formula>Billing_Street__c</formula>
        <name>update billing street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_city</fullName>
        <field>BillingCity</field>
        <formula>City__r.Name</formula>
        <name>update city</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_state</fullName>
        <field>BillingState</field>
        <formula>TEXT( State__c )</formula>
        <name>update state</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Customer Number for Account</fullName>
        <actions>
            <name>UpdateCustomerId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.LastName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Customer Number for Account</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>update city%2Fstate%2Fpin code</fullName>
        <actions>
            <name>Update_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Pin_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_billing_street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_city</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_state</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.LastName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
