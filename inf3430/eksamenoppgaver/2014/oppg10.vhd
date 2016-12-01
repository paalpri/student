library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity veksle is
  port
    (
      rst : in std_logic; --asynkron reset
      clk : in std_logic; --klokke
      empty : in std_logic; --tom for vekslepenger
      money_in : in std_logic; --puls for å starte veksling
      money_type : in std_logic_vector(2 downto 0); --seddel/mynttype
      kr20_out : out std_logic; --20 kroner puls
      kr10_out : out std_logic; --10 kroner puls
      kr5_out : out std_logic; --5 kroner puls
      kr1_out : out std_logic; --1 kroner puls
      ready : inout std_logic; --veksling ferdig
      money_back : out std_logic --retur av feil type mynt
      );
end entity veksle;

architecture rtl of veksle is

  type state_type is (IDLE_ST,KR20_1ST,KR10_1ST,KR20_2ST,KR10_2ST,KR10_3ST,KR5_1ST,KR1_1ST,);
  signal PRESENT_STATE, NEXT_STATE : state_type;
  signal count : unsigned (2 downto 0);

begin


  variable count : unsigned(3 downto 0);
  process(clk,rst)

  begin
    if(rst = '1') then
      NEXT_STATE <= IDLE_ST;
      ready <= '1';
      count <= (others => '0');
    elsif(rising_edge(clk)) then
      PRESENT_STATE <= NEXT_STATE;
    end if
  end process

      process(PRESENT_STATE)
      begin
        kr20_out <= '0';
        kr10_out <= '0';
        kr5_out <= '0';
        kr1_out <= '0';
        case PRESENT_STATE is
          when IDLE_ST =>
            if(empty = '1') or money_in = '0' then
              NEXT_STATE <= IDLE_ST;
            else
              ready <= '0';
              case money_type is
                when "001" =>
                  count <= 8;
                  NEXT_STATE <= KR20_1ST;
                when "010" =>
                  count <= 3;
                  NEXT_STATE <= KR20_1ST;
                when "011" =>
                  count <= 1;
                  NEXT_STATE <= KR20_2ST;
                when "100" =>
                  NEXT_STATE <= KR10_3ST;
                when "101" =>
                  NEXT_STATE <= KR5_1ST;
                when "110" =>
                  NEXT_STATE <= KR1_1ST;
                when others =>
                  money_back <= '1';
                  ready <= '1';
              end case;
            end if;
          when KR20_1ST =>
            kr20_out <= '1';
            count <= count - 1;
            if(count /= 0) then
              NEXT_STATE <= KR20_1ST;
            else
              count <= 2;
              NEXT_STATE <= KR10_1ST;
            end if;
          when KR10_1ST =>
            kr10_out <= '1';
            count <= count - 1;
            if(count /= 0) then
              NEXT_STATE <= KR10_1ST;
            else
              ready <= '1';
              NEXT_STATE <= IDLE_ST;
            end if;
          when KR20_2ST =>
            kr20_out <= '1';
            count <= count -1;
            if(count /= 0) then
              NEXT_STATE <= KR20_2ST;
            else
              NEXT_STATE <= KR10_2ST;
            end if;
          when KR10_2ST =>
            NEXT_STATE <= IDLE_ST;
          when KR10_3ST =>
            kr10_out <= '1';
            NEXT_STATE <= KR5_1ST;
          when KR5_1ST =>
            kr5_out <= '1';
            NEXT_STATE <= kr5_out;
          when KR10_1ST =>
            kr1_out <= '1';
            count <= count -1;
            if(count /= 0) then
              NEXT_STATE <= KR1_1ST;
            else
              ready <= '1';
              NEXT_STATE <= IDLE_ST;
            end if;
        end case;
      end process;
end rtl;
