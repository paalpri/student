------------------------------------------------------------------------------
-- Assumptions:                                                             --
--     Only one address is given per data transaction                       --
--     Only full 32b transactions are requested                             --
--                                                                          --
-- Author: tonnesfn@ifi.uio.no                                              --
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture beh of Axi4LiteBfm is

    -- Constants --
    constant memoryOffset : integer := 268435456;   -- Offset in bytes
    constant memorySize   : integer := 32; -- Size in bytes

    type t_memory is array (0 to ((memorySize/4)-1)) of std_logic_vector(31 downto 0); 
    signal memory : t_memory;
    
    type t_writeChannelState is (e_waitForAW, e_waitForW, e_writeToMemory, e_respond);
    signal writeChannelState : t_writeChannelState;
    
    type t_readChannelState is (e_waitForAR, e_waitForR, e_respond);
    signal readChannelState : t_readChannelState;
    
begin

    p_WriteChannel : process(axi_aclk, axi_aresetn)
        variable writeAddress : std_logic_vector(31 downto 0);
    begin
        if (axi_aresetn = '0') then
            writeChannelState <= e_waitForAW;
            
            axi_awready <= '0';
            axi_wready  <= '0';
            axi_bvalid  <= '0';
            axi_bresp   <= "00";
            
        elsif(rising_edge(axi_aclk)) then
        
            -- Default values:
            axi_awready <= '1';
            axi_wready  <= '1';
            axi_bresp   <= "00";
            axi_bvalid  <= '0';
                        
            case writeChannelState is
                when e_waitForAW =>
                    if (axi_awvalid = '1') then
                        writeAddress      := axi_awaddr;
                        writeChannelState <= e_waitForW;
                    end if;
                    
                    assert(axi_wvalid = '0') report "Write was set valid without a prior address" severity note;
                when e_waitForW =>
                    if (axi_awvalid = '1') then
                        writeAddress := axi_awaddr;
                    end if;
                    
                    if (axi_wvalid = '1') then
                        writeChannelState <= e_writeToMemory;
                    end if;
                when e_writeToMemory =>
                    assert(to_integer(unsigned(writeAddress)) >= memoryOffset) report "Address is below the given offset" severity failure;
                    assert(to_integer(unsigned(writeAddress)) < (memoryOffset + memorySize)) report "Address is above the given offset and memory size" severity failure;
                    memory(to_integer(unsigned(writeAddress))/4 - (memoryOffset/4)) <= axi_wdata;
                    writeChannelState <= e_respond;
                    
                when e_respond =>
                    axi_bresp  <= "00"; -- OKAY response
                    axi_bvalid <= '1';
                    writeChannelState <= e_waitForAW;
                
                when others =>
                    writeChannelState <= e_waitForAW;
            end case;
        end if;    
    end process p_WriteChannel;

    p_ReadChannel : process(axi_aclk, axi_aresetn)
        variable readAddress : std_logic_vector(31 downto 0);
    begin
        if (axi_aresetn = '0') then
            axi_arready <= '0';
            axi_rresp   <= "00";
            axi_rvalid  <= '0';
            axi_rdata   <= (others => 'X');
        elsif(rising_edge(axi_aclk)) then
            
            axi_arready <= '1';
            axi_rvalid  <= '0';
            
            case readChannelState is
                when e_waitForAR =>
                    if (axi_arvalid = '1') then
                        axi_arready <= '1';
                        assert((unsigned(axi_araddr) mod 4) = 0) report "Read: Address must be word aligned." severity failure;
                        readAddress := axi_araddr;
                        readChannelState <= e_waitForR;
                    end if;
                when e_waitForR =>
                
                    if (axi_rready = '1') then
                        assert(to_integer(unsigned(readAddress)) >= memoryOffset) report "Read: Address is below the given offset" severity failure;
                        assert(to_integer(unsigned(readAddress)) < (memoryOffset + memorySize)) report "Read: Address is above the given offset and memory size" severity failure;
                        axi_rdata  <= memory(to_integer(unsigned(readAddress))/4 - (memoryOffset/4));
                        axi_rresp  <= "00"; -- OKAY response
                        axi_rvalid <= '1';
                        
                        readChannelState <= e_waitForAR;
                    end if;
                when others =>
                    readChannelState <= e_waitForAR;
            end case;
        
        end if;  
    end process p_ReadChannel;

    p_assert : process(axi_aresetn)
    begin
        if (axi_aresetn = '1') then
            assert(axi_awprot = "000")  report "Only AWProt = 000 is supported." severity failure;
            assert(axi_arprot = "000")  report "Only ARProt = 000 is supported." severity failure;
            assert(axi_wstrb  = "1111") report "Only WStrb = 1111 is supported." severity failure;
        end if;
    end process p_assert;
    
end architecture beh;
