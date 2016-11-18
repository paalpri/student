library IEEE;
use IEEE.std_logic_1164.all;
use work.seg7_pkg.all;


architecture beh of seg7ctrl is
	component decoder
	port(
		 SW	: in std_logic_vector(1 downto 0); -- kanskje endre navn
		 LD	: out std_logic_vector(3 downto 0)
		);
	end component decoder;	
		
	component counter
		port(
			CLK        : in  std_logic; 
			RESET      : in  std_logic; 
			COUNT      : out std_logic_vector(1 downto 0)
		);
	end component counter;
	
	component slowclock is
	port
	(
		mclk : in std_logic;
		SCLK : out std_logic
	);
	end component slowclock;
	

	
  
  signal LD 		 : std_logic_vector(3 downto 0);
  signal CLKi        : std_logic; 
  signal RESETi      : std_logic; 
  signal COUNTi      : std_logic_vector(1 downto 0);
  signal ani		 : std_logic_vector(3 downto 0);
 

begin

	RESETi <= reset;
	a_n <= LD;
	
	UUT2: slowclock
	port map(
			mclk => mclk,
			sclk => CLKi
			);
	
	UUT1: counter
	port map(
			CLK => clki,
			RESET => RESETi,
			COUNT => COUNTi 	
		);

	UUT0: decoder
	port map(
			SW => COUNTi,
			LD => LD	
		);
		
	
  
  blastoise:
  process (LD)
  begin
   
    if (LD(3) = '0') then
      abcdefgdec_n <= four2eightByte(d3,dec(3));
    end if;
    if (LD(2) = '0') then
      abcdefgdec_n <= four2eightByte(d2,dec(2));
    end if;
    if LD(1) = '0' then
     abcdefgdec_n <= four2eightByte(d1,dec(1));
    end if;
    if LD(0) = '0' then
      abcdefgdec_n <= four2eightByte(d0,dec(0));
    end if;
  end process blastoise;
  
end beh;
  
  
  