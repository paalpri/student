library ieee;
use ieee.std_logic_1164.all;

entity AxiSp is
  port (clk     : in  std_logic;
        aresetn : in  std_logic;

        -- Input/output
        btn_save  : in  std_logic;
        btn_load  : in  std_logic;
        switches  : in  std_logic_vector(7 downto 0);
        SP_output : out std_logic_vector(7 downto 0);
        LEDs      : out std_logic_vector(7 downto 0);
        
        -- AW channel
        axi_awaddr  : out std_logic_vector(31 downto 0);
        axi_awprot  : out std_logic_vector(2 downto 0);
        axi_awvalid : out std_logic;
        axi_awready : in  std_logic;

        -- W channel
        axi_wdata  : out std_logic_vector(31 downto 0);
        axi_wstrb  : out std_logic_vector(3 downto 0);
        axi_wvalid : out std_logic;
        axi_wready : in  std_logic;

        -- B channel
        axi_bresp  : in  std_logic_vector(1 downto 0);
        axi_bvalid : in  std_logic;
        axi_bready : out std_logic;

        -- AR channel
        axi_araddr  : out std_logic_vector(31 downto 0);
        axi_arprot  : out std_logic_vector(2 downto 0);
        axi_arvalid : out std_logic;
        axi_arready : in  std_logic;

        -- R channel
        axi_rdata  : in  std_logic_vector(31 downto 0);
        axi_rresp  : in  std_logic_vector(1 downto 0);
        axi_rvalid : in  std_logic;
        axi_rready : out std_logic
       );
end AxiSp;
