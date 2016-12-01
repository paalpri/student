------------------------------------------------------------------------------
-- Bus functional model of the Axi4 lite interface used in exercise 4B,     -- 
-- compatible with the xilinx interface used to the Zynq PS.                --
--                                                                          --
-- Author: tonnesfn@ifi.uio.no                                              --
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Axi4LiteBfm is
  port(axi_aclk	     : in  std_logic;
       axi_aresetn	 : in  std_logic;
       
       -- AW channel
       axi_awaddr	 : in  std_logic_vector(31 downto 0);
       axi_awprot	 : in  std_logic_vector(2 downto 0);
       axi_awvalid	 : in  std_logic;
       axi_awready	 : out std_logic;
       
       -- W channel
       axi_wdata	 : in  std_logic_vector(31 downto 0);
       axi_wstrb	 : in  std_logic_vector(3 downto 0);
       axi_wvalid	 : in  std_logic;
       axi_wready	 : out std_logic;
       
       -- B channel
       axi_bresp	 : out std_logic_vector(1 downto 0);
       axi_bvalid	 : out std_logic;
       axi_bready	 : in  std_logic;
       
       -- AR channel
       axi_araddr	 : in  std_logic_vector(31 downto 0);
       axi_arprot	 : in  std_logic_vector(2 downto 0);
       axi_arvalid	 : in  std_logic;
       axi_arready	 : out std_logic;
       
       -- R channel
       axi_rdata	 : out std_logic_vector(31 downto 0);
       axi_rresp	 : out std_logic_vector(1 downto 0);
       axi_rvalid	 : out std_logic;
       axi_rready	 : in  std_logic
      );
end Axi4LiteBfm;
