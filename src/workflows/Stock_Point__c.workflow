<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateSTNSeriesNo</fullName>
        <description>STN Series No should be reset to 0</description>
        <field>STN_Series__c</field>
        <formula>0</formula>
        <name>Update STN Series No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update STN Series No</fullName>
        <actions>
            <name>UpdateSTNSeriesNo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The Stock Point Series No STN Series No should be reset start of every Fiscal Year to 0</description>
        <formula>MONTH(TODAY() ) = 4 &amp;&amp;  DAY(TODAY()) &gt;= 1</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
