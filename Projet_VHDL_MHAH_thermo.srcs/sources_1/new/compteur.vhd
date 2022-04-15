----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2022 10:52:13
-- Design Name: 
-- Module Name: compteur - Behavioral
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

entity compteur is
generic(FIN_COMPTEUR : integer);
Port ( 
    clk : in std_logic;
    rst : in std_logic;
    timer : in std_logic;
    start_compteur : in std_logic;
    compteur_end : out std_logic);
end compteur;

architecture Behavioral of compteur is

signal compteur : integer;

begin
process(start_compteur, clk, rst)
begin
if rst = '1' then 
    compteur <= 0;
    else if rising_edge(clk) then
        if start_compteur = '1' then 
            if compteur = FIN_COMPTEUR then
                compteur <= 0;
                compteur_end <= '1';
            else 
                compteur_end <= '0';
                if timer = '1' then
                    compteur <= compteur + 1;
                end if;
            end if;
         end if;
    end if;
end if;
end process;
end Behavioral;
