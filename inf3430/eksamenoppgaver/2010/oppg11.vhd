library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity MANCHESTER is
  port
    (
      RESET : in std_logic; --Asynkron reset
      CLK : in std_logic; --Klokke
      DATA_RDY : in std_logic; --Viser gyldige data inn
      SDI : in std_logic; --Serielle input data
      MANU : out std_logic --Manchester kodet sekvens ut
      );
end MANCHESTER;
architecture RTL_MANCHESTER of MANCHESTER is

  type state_type is (MANU_IDLE_ST,MANU_SAMPLE_ST,MANU_CODE_ST);
  signal curr_st,next_st : state_type;


  process(clk,reset)
    if(reset = '1') then
      curr_st <= MANU_Idle_st;
    elsif(rising_edge(clk)) then
      curr_st <= next_st;
    end if;
  end

    process(curr_st,data_rdy,sdi)
      case curr_st is
        when MANU_Idle_st =>
          if(data_rdy = '1') then
            next_st <= MANU_SAMPLE_ST;
          end if;
        when MANU_SAMPLE_ST =>
          next_st <= MANU_CODE_ST;
          if(sdi = '1') then
            MANU <= '1';
          else
            MANU <= '0';
          end if;
        when MANU_CODE_ST =>
          MANU <= not MANU;
          if(data_rdy = '1') then
            next_st <= MANU_SAMPLE_ST;
          else
            next_st <= MANU_Idle_st;
          end if;
      end case;
    end process;

end RTL_MANCHESTER;
