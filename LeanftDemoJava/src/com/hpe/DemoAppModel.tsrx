<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<applicationModel>
    <name>Application Model</name>
    <className>DemoAppModel</className>
    <objects>
        <object type="Page" technology="Web">
            <name> Advantage Shopping</name>
            <codeName>AdvantageShoppingPage</codeName>
            <identification/>
            <children>
                <object type="Button" technology="Web">
                    <name>LOGIN</name>
                    <codeName>LoginBtn</codeName>
                    <identification>
                        <properties>
                            <property name="ButtonType" type="string" isRegExp="false">submit</property>
                            <property name="TagName" type="string" isRegExp="false">BUTTON</property>
                            <property name="Name" type="string" isRegExp="false">LOGIN</property>
                        </properties>
                    </identification>
                </object>
                <object type="EditField" technology="Web">
                    <name>orderPaymenLogin_username</name>
                    <codeName>UserName</codeName>
                    <identification>
                        <properties>
                            <property name="Type" type="string" isRegExp="false">text</property>
                            <property name="TagName" type="string" isRegExp="false">INPUT</property>
                            <property name="Name" type="string" isRegExp="false">orderPaymenLogin_username</property>
                        </properties>
                    </identification>
                </object>
                <object type="EditField" technology="Web">
                    <name>orderPaymenLogin_password</name>
                    <codeName>Password</codeName>
                    <identification>
                        <properties>
                            <property name="Type" type="string" isRegExp="false">password</property>
                            <property name="TagName" type="string" isRegExp="false">INPUT</property>
                            <property name="Name" type="string" isRegExp="false">orderPaymenLogin_password</property>
                        </properties>
                    </identification>
                </object>
            </children>
        </object>
    </objects>
</applicationModel>
