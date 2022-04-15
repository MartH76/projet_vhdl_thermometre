----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.03.2022 16:48:32
-- Design Name: 
-- Module Name: NegToPos - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NegToPos is
Port ( 
    temp_buff : in std_logic_vector(15 downto 0);
    sign : out std_logic;
    virgule : out std_logic;
    clk : in std_logic;
    rst : in std_logic;
    temp_8b : out std_logic_vector(7 downto 0));
end NegToPos;

architecture Behavioral of NegToPos is

signal s_temp_buff :  unsigned(7 downto 0);
signal s_temp_buff2 : unsigned(7 downto 0);
begin

process(clk, rst)
begin 
if rst = '1' then 
    temp_8b <= "00000000";
    s_temp_buff <= "00000000";
    s_temp_buff2 <= "00000000";
    sign <= '1';
else if rising_edge(clk) then
        if temp_buff(15 downto 8) = "00000000" then -- on a une valeur positive
            sign <= '1'; -- code de valeur positive
            temp_8b <= '0' & temp_buff(7 downto 1); -- on décale à droite pour diviser par 2
        else 
            sign <= '0'; -- on a une valeur negative 
            s_temp_buff <= unsigned(not(temp_buff(7 downto 0))); -- on commence par inverser 
            s_temp_buff2 <= s_temp_buff + "00000001"; -- +1 pour finir complement a 2           
            temp_8b <= '0' & std_logic_vector(s_temp_buff2(7 downto 1)); -- on decale a droite pour diviser par 2
        end if;    
        virgule <= temp_buff(0); -- la virgule est le lsb du bus temperature
    end if;   
end if;

end process;
end Behavioral;
