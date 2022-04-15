
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AN_counter is
    Port (
    clk: in std_logic;
    rst: in std_logic;
    timer : in std_logic;
    AN : out std_logic_vector(7 downto 0));
end AN_counter;

architecture Behavioral of AN_counter is

signal i: integer;
signal An_temp1,AN_temp2: std_logic_vector(7 downto 0);

begin
process(clk,rst)
begin
    if rst='1' then
        AN<="11111110";
        AN_temp1<="11111110";
        AN_temp2<="11111110";
    elsif rising_edge(clk) then
        if timer = '1' then 
            AN_temp2(7 downto 1)<=AN_temp1(6 downto 0); -- on decale les bits pour avoir une rotation de AN
            AN_temp2(0)<=AN_temp1(7);
            AN_temp1<=AN_temp2;
            AN<=AN_temp2;
        end if;
    end if;
end process;
end Behavioral;
