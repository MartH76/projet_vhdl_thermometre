----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2022 09:07:37
-- Design Name: 
-- Module Name: timer - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity timer is
Port ( 
    clk : in std_logic;
    rst : in std_logic;
    timer_out : out std_logic);
end timer;

architecture Behavioral of timer is

signal tampon : integer range 101 downto 0;
begin
process(rst, clk)
begin 
if rst = '1' then 
    tampon <= 0;
else        
    if rising_edge(clk) then  
        if tampon = 99 then
            tampon <= 0;
            timer_out <= '1';
        else 
            tampon <= tampon + 1;
            timer_out <= '0';
        end if;
    end if;
end if;
end process;
end Behavioral;
