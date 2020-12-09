/*
 * This patch for my HD7850.
 * You should not use if you don't have the same graphics card as mine.
 */
DefinitionBlock ("", "SSDT", 2, "ACDT", "AMDGPU", 0x00001000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.GFX0, DeviceObj)
    External (_SB_.PCI0.PEG0, DeviceObj)
    External (_SB_.PCI0.PEG0.PEGP, DeviceObj)

    Scope (\_SB.PCI0)
    {
        // Follow your motherboard structure regarding the scope hierarchy.
        // Depending on your method you may rename PEGP to GFX0.
        Scope (PEG0)
        {
            Scope (PEGP)
            {
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    Local0 = Package ()
                        {
                            // Write the main monitor index (currently @1) here, the value does not matter
                            "@1,AAPL,boot-display", 
                            Buffer (Zero){},

                            // GPU model name is absolutely unimportant for GPU functioning
                            "model",
                            Buffer ()
                            {
                                "AMD Radeon HD 7850"
                            },

                            // Only use this with automatic connector detection when you need manual priority.
                            // Each value is a sense id(could be seen in debug log) to get a higher priority.
                            // Automatic ordering is done by type: LVDS, DVI, HDMI, DP, VGA.
                            // You may leave this empty to order all the connectors by type.
                            // Assume autodetected connectors: 0x03 DP, 0x02 DVI_D, 0x06 HDMI, 0x05 DVI_D, 0x04 VGA
                            // With the value pri will become: 0x0005 , 0x0001    , 0x0004   , 0x0003    , 0x0002
                            "connector-priority",
                            Buffer ()
                            {
                                 0x02, 0x01                                       // ..
                            }
                        }
                    DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                    Return (Local0)
                }
            }
        }//PEG0

        Method (DTGP, 5, NotSerialized)
        {
            If ((Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b") /* Unknown UUID */))
            {
                If ((Arg1 == One))
                {
                    If ((Arg2 == Zero))
                    {
                        Arg4 = Buffer (One)
                            {
                                 0x03                                             // .
                            }
                        Return (One)
                    }

                    If ((Arg2 == One))
                    {
                        Return (One)
                    }
                }
            }

            Arg4 = Buffer (One)
                {
                     0x00                                             // .
                }
            Return (Zero)
        }
    }
}

