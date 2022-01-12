/*
 * A tiny SSDT for ASUS-B250M.
 * It's a alternate for all SSDT hotpatches.
 * Credit: @JFZ (https://github.com/lichongjia)
 */
DefinitionBlock ("", "SSDT", 2, "JFZ", "TinySSDT", 0x00001000)
{
    External (_PR_.CPU0, ProcessorObj)
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.GFX0, DeviceObj)
    External (_SB_.PCI0.LPCB, DeviceObj)
    External (_SB_.PCI0.SBUS, DeviceObj)
 /* External (XPRW, MethodObj)    // 0D/6D wakeup patch:2 Arguments */

    If (_OSI ("Darwin"))
    {
        Scope (\_SB)
        {
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
                Method (_STA, 0, NotSerialized)  // _STA: Status
                {
                    Return (0x0F)
                }
            }

            Scope (PCI0)
            {
                Scope (GFX0)
                {
                    OperationRegion (RMP3, PCI_Config, Zero, 0x14)

                    /* Add Device PNLF for backlight control */
                    Device (PNLF)
                    {
                     // Name (_ADR, Zero)  // _ADR: Address
                        Name (_HID, EisaId ("APP0002"))  // _HID: Hardware ID
                        Name (_CID, "backlight")  // _CID: Compatible ID
                        // _UID is set depending on PWMMax to match profiles in WhateverGreen.kext https://github.com/acidanthera/WhateverGreen/blob/1.4.7/WhateverGreen/kern_weg.cpp#L32
                        // 14: Sandy/Ivy 0x710
                        // 15: Haswell/Broadwell 0xad9
                        // 16: Skylake/KabyLake 0x56c (and some Haswell, example 0xa2e0008)
                        // 17: custom LMAX=0x7a1
                        // 18: custom LMAX=0x1499
                        // 19: CoffeeLake 0xffff
                        // 99: Other (requires custom profile using WhateverGreen.kext via DeviceProperties applbkl-name and applbkl-data)
                        Name (_UID, 0x10)  // _UID: Unique ID
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0B)
                        }
                    }
                }

                Scope (LPCB)
                {
                    /* Add Device EC for AppleUsbPower compatibility table */ 
                    Device (EC)
                    {
                        Name (_HID, "ACID0001")  // _HID: Hardware ID
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }
                    }

                    /* Add Device ALS0, starting with macOS 10.15 Ambient Light Sensor presence is required for backlight functioning */
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
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }
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

                /* Add Device MCHC for SMBus compatibility */
                Device (MCHC)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        Return (0x0F)
                    }
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
                        Method (_STA, 0, NotSerialized)  // _STA: Status
                        {
                            Return (0x0F)
                        }
                    }
                }
            }//PCI0
        }//\_SB

        /*
         * 0D/6D wakeup patch
         * In config.plist->ACPI->Patch: GPRW to XPRW
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

        /* Add PMPM Method for XCPM power management compatibility */
        Method (PMPM, 4, NotSerialized)
        {
            If (LEqual (Arg2, Zero))
            {
                Return (Buffer (One) { 0x03 })
            }

           Return (Package (0x02)
           {
               "plugin-type", 
               One
           })
        }

        If (CondRefOf (\_PR.CPU0)) {
            If ((ObjectType (\_PR.CPU0) == 0x0C)) {
                Scope (\_PR.CPU0) {
                    If (_OSI ("Darwin")) {
                        Method (_DSM, 4, NotSerialized)  
                        {
                            Return (PMPM (Arg0, Arg1, Arg2, Arg3))
                        }
                    }
                }
            }
        }

    }//if OS=Darwin
}
