/*
 * This file is a tiny SSDT for ASUS-B250M.
 * It's a alternate for all SSDT patches.
 * Credit: @JFZ (https://github.com/lichongjia)
 */
DefinitionBlock ("", "SSDT", 2, "JFZ", "TinySSDT", 0x00001000)
{
    External (_PR_.CPU0, ProcessorObj)
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.GFX0, DeviceObj)
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.PCI0.SBUS, DeviceObj)
    External (RMCF.BKLT, IntObj)
    External (RMCF.FBTP, IntObj)
    External (RMCF.GRAN, IntObj)
    External (RMCF.LEVW, IntObj)
    External (RMCF.LMAX, IntObj)
 /* External (XPRW, MethodObj)    // 0D/6D wakeup patch:2 Arguments */

    If (_OSI ("Darwin"))
    {
        Scope (\_SB)
        {
            Scope (PCI0)
            {
                Scope (GFX0)
                {
                    OperationRegion (RMP3, PCI_Config, Zero, 0x14)

                    /* Add Device PNLF, This patch comes from WhateverGreen */
                    Device (PNLF)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        Name (_HID, EisaId ("APP0002"))  // _HID: Hardware ID
                        Name (_CID, "backlight")  // _CID: Compatible ID
                        Name (_UID, Zero)  // _UID: Unique ID
                        Name (_STA, 0x0B)  // _STA: Status
                        Field (^RMP3, AnyAcc, NoLock, Preserve)
                        {
                            Offset (0x02), 
                            GDID,   16, 
                            Offset (0x10), 
                            BAR1,   32
                        }

                        OperationRegion (RMB1, SystemMemory, (BAR1 & 0xFFFFFFFFFFFFFFF0), 0x000E1184)
                        Field (RMB1, AnyAcc, Lock, Preserve)
                        {
                            Offset (0x48250), 
                            LEV2,   32, 
                            LEVL,   32, 
                            Offset (0x70040), 
                            P0BL,   32, 
                            Offset (0xC2000), 
                            GRAN,   32, 
                            Offset (0xC8250), 
                            LEVW,   32, 
                            LEVX,   32, 
                            LEVD,   32, 
                            Offset (0xE1180), 
                            PCHL,   32
                        }

                        Method (INI1, 1, NotSerialized)
                        {
                            If ((Zero == (0x02 & Arg0)))
                            {
                                Local5 = 0xC0000000
                                If (CondRefOf (\RMCF.LEVW))
                                {
                                    If ((Ones != \RMCF.LEVW))
                                    {
                                        Local5 = \RMCF.LEVW /* External reference */
                                    }
                                }

                                ^LEVW = Local5
                            }

                            If ((0x04 & Arg0))
                            {
                                If (CondRefOf (\RMCF.GRAN))
                                {
                                    ^GRAN = \RMCF.GRAN /* External reference */
                                }
                                Else
                                {
                                    ^GRAN = Zero
                                }
                            }
                        }

                        Method (_INI, 0, NotSerialized)  // _INI: Initialize
                        {
                            Local4 = One
                            If (CondRefOf (\RMCF.BKLT))
                            {
                                Local4 = \RMCF.BKLT /* External reference */
                            }

                            If (!(One & Local4))
                            {
                                Return (Zero)
                            }

                            Local0 = ^GDID /* \_SB_.PCI0.GFX0.PNLF.GDID */
                            Local2 = Ones
                            If (CondRefOf (\RMCF.LMAX))
                            {
                                Local2 = \RMCF.LMAX /* External reference */
                            }

                            Local3 = Zero
                            If (CondRefOf (\RMCF.FBTP))
                            {
                                Local3 = \RMCF.FBTP /* External reference */
                            }

                            If (((One == Local3) || (Ones != Match (Package (0x10)
                                                {
                                                    0x010B, 
                                                    0x0102, 
                                                    0x0106, 
                                                    0x1106, 
                                                    0x1601, 
                                                    0x0116, 
                                                    0x0126, 
                                                    0x0112, 
                                                    0x0122, 
                                                    0x0152, 
                                                    0x0156, 
                                                    0x0162, 
                                                    0x0166, 
                                                    0x016A, 
                                                    0x46, 
                                                    0x42
                                                }, MEQ, Local0, MTR, Zero, Zero))))
                            {
                                If ((Ones == Local2))
                                {
                                    Local2 = 0x0710
                                }

                                Local1 = (^LEVX >> 0x10)
                                If (!Local1)
                                {
                                    Local1 = Local2
                                }

                                If ((!(0x08 & Local4) && (Local2 != Local1)))
                                {
                                    Local0 = ((^LEVL * Local2) / Local1)
                                    Local3 = (Local2 << 0x10)
                                    If ((Local2 > Local1))
                                    {
                                        ^LEVX = Local3
                                        ^LEVL = Local0
                                    }
                                    Else
                                    {
                                        ^LEVL = Local0
                                        ^LEVX = Local3
                                    }
                                }
                            }
                            ElseIf (((0x03 == Local3) || (Ones != Match (Package (0x04)
                                                {
                                                    0x3E9B, 
                                                    0x3EA5, 
                                                    0x3E92, 
                                                    0x3E91
                                                }, MEQ, Local0, MTR, Zero, Zero))))
                            {
                                If ((Ones == Local2))
                                {
                                    Local2 = 0xFFFF
                                }

                                INI1 (Local4)
                                Local1 = ^LEVX /* \_SB_.PCI0.GFX0.PNLF.LEVX */
                                If (!Local1)
                                {
                                    Local1 = Local2
                                }

                                If ((!(0x08 & Local4) && (Local2 != Local1)))
                                {
                                    Local0 = ((^LEVD * Local2) / Local1)
                                    If ((Local2 > Local1))
                                    {
                                        ^LEVX = Local2
                                        ^LEVD = Local0
                                    }
                                    Else
                                    {
                                        ^LEVD = Local0
                                        ^LEVX = Local2
                                    }
                                }
                            }
                            Else
                            {
                                If ((Ones == Local2))
                                {
                                    If ((Ones != Match (Package (0x16)
                                                    {
                                                        0x0D26, 
                                                        0x0A26, 
                                                        0x0D22, 
                                                        0x0412, 
                                                        0x0416, 
                                                        0x0A16, 
                                                        0x0A1E, 
                                                        0x0A1E, 
                                                        0x0A2E, 
                                                        0x041E, 
                                                        0x041A, 
                                                        0x0BD1, 
                                                        0x0BD2, 
                                                        0x0BD3, 
                                                        0x1606, 
                                                        0x160E, 
                                                        0x1616, 
                                                        0x161E, 
                                                        0x1626, 
                                                        0x1622, 
                                                        0x1612, 
                                                        0x162B
                                                    }, MEQ, Local0, MTR, Zero, Zero)))
                                    {
                                        Local2 = 0x0AD9
                                    }
                                    Else
                                    {
                                        Local2 = 0x056C
                                    }
                                }

                                INI1 (Local4)
                                Local1 = (^LEVX >> 0x10)
                                If (!Local1)
                                {
                                    Local1 = Local2
                                }

                                If ((!(0x08 & Local4) && (Local2 != Local1)))
                                {
                                    Local0 = ((((^LEVX & 0xFFFF) * Local2) / Local1) | 
                                        (Local2 << 0x10))
                                    ^LEVX = Local0
                                }
                            }

                            If ((Local2 == 0x0710))
                            {
                                _UID = 0x0E
                            }
                            ElseIf ((Local2 == 0x0AD9))
                            {
                                _UID = 0x0F
                            }
                            ElseIf ((Local2 == 0x056C))
                            {
                                _UID = 0x10
                            }
                            ElseIf ((Local2 == 0x07A1))
                            {
                                _UID = 0x11
                            }
                            ElseIf ((Local2 == 0x1499))
                            {
                                _UID = 0x12
                            }
                            ElseIf ((Local2 == 0xFFFF))
                            {
                                _UID = 0x13
                            }
                            Else
                            {
                                _UID = 0x63
                            }
                        }
                    }//PNLF
                }//GFX0

                Scope (LPCB)
                {
                    /* Add Device ALS0, Starting with macOS 10.15 Ambient Light Sensor presence is required for backlight functioning */
                    Device (ALS0)
                    {
                        Name (_HID, "ACPI0008" /* Ambient Light Sensor Device */)  // _HID: Hardware ID
                        Name (_CID, "smc-als")  // _CID: Compatible ID
                        Name (_ALI, 0x012C)  // _ALI: Ambient Light Illuminance
                        Name (_ALR, Package (0x01)  // _ALR: Ambient Light Response
                        {
                            Package (0x02)
                            {
                                0x64, 
                                0x012C
                            }
                        })
                    }

                    /* Add Device EC, AppleUsbPower compatibility table */ 
                    Device (EC)
                    {
                        Name (_HID, "ACID0001")  // _HID: Hardware ID
                    }

                    /* Add Device DMAC */
                    Device (DMAC)
                    {
                        Name (_HID, EisaId ("PNP0200") /* PC-class DMA Controller */)  // _HID: Hardware ID
                        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
                        {
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x20,               // Length
                                )
                            IO (Decode16,
                                0x0081,             // Range Minimum
                                0x0081,             // Range Maximum
                                0x01,               // Alignment
                                0x11,               // Length
                                )
                            IO (Decode16,
                                0x0093,             // Range Minimum
                                0x0093,             // Range Maximum
                                0x01,               // Alignment
                                0x0D,               // Length
                                )
                            IO (Decode16,
                                0x00C0,             // Range Minimum
                                0x00C0,             // Range Maximum
                                0x01,               // Alignment
                                0x20,               // Length
                                )
                            DMA (Compatibility, NotBusMaster, Transfer8_16, )
                                {4}
                        })
                    }

                }//LPCB

                /* Add Device MCHC, SMBus compatibility table */
                Device (MCHC)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                }

                Scope (SBUS)
                {
                    Device (BUS0)
                    {
                        Name (_CID, "smbus")  // _CID: Compatible ID
                        Name (_ADR, Zero)  // _ADR: Address
                        Device (DVL0)
                        {
                            Name (_ADR, 0x57)  // _ADR: Address
                            Name (_CID, "diagsvault")  // _CID: Compatible ID
                            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                            {
                                If (!Arg2)
                                {
                                    Return (Buffer (One)
                                    {
                                         0x57                                             // W
                                    })
                                }

                                Return (Package (0x02)
                                {
                                    "address", 
                                    0x57
                                })
                            }
                        }
                    }
                }

            }//PCI0
            
            /* Add Device USBX for Skylake and newer */
            Device (USBX)
            {
                Name (_ADR, Zero)  // _ADR: Address
                Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                {
                    If ((Arg2 == Zero))
                    {
                        Return (Buffer (One)
                        {
                             0x03                                             // .
                        })
                    }

                    Return (Package (0x08)
                    {
                        "kUSBSleepPowerSupply", 
                        0x13EC, 
                        "kUSBSleepPortCurrentLimit", 
                        0x0834, 
                        "kUSBWakePowerSupply", 
                        0x13EC, 
                        "kUSBWakePortCurrentLimit", 
                        0x0834
                    })
                }
            }

        }//\_SB
        
        /*
         * 0D/6D wakeup patch
         * In config ACPI: GPRW to XPRW
         * Find:     47505257 02
         * Replace:  58505257 02
         */
        /*
        Method (GPRW, 2, NotSerialized)
        {
            While (One)
            {
                If ((0x6D == Arg0))
                {
                    Return (Package ()
                    {
                        0x6D, 
                        Zero
                    })
                }

                If ((0x0D == Arg0))
                {
                    Return (Package ()
                    {
                        0x0D, 
                        Zero
                    })
                }

                Break
            }

            Return (XPRW (Arg0, Arg1))
        }
        */

        /* Add Device MEM2 */
        Device (MEM2)
        {
            Name (_HID, EisaId ("PNP0C01") /* System Board */)  // _HID: Hardware ID
            Name (_UID, 0x02)  // _UID: Unique ID
            Name (CRS, ResourceTemplate ()
            {
                Memory32Fixed (ReadWrite,
                    0x20000000,         // Address Base
                    0x00200000,         // Address Length
                    )
                Memory32Fixed (ReadWrite,
                    0x40000000,         // Address Base
                    0x00200000,         // Address Length
                    )
            })
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Return (CRS) /* \MEM2.CRS_ */
            }
        }

        /* XCPM power management compatibility table */
        Scope (\_PR.CPU0)
        {
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                Local0 = Package (0x02)
                    {
                        "plugin-type", 
                        One
                    }
                DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                Return (Local0)
            }
        }

        /* Add DTGP Method */
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
    }//if OS=Darwin
}

