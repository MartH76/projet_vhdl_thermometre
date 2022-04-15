----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.01.2022 14:56:19
-- Design Name: 
-- Module Name: puissance_10 - Behavioral
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

entity puissance_10 is
Port (
    clk         : in std_logic;
    temperature  : in std_logic_vector(7 downto 0);
    centaine       : out std_logic_vector (3 downto 0);
    dizaine         : out std_logic_vector (3 downto 0);
    unite          : out std_logic_vector (3 downto 0);
    rst      : in std_logic);
end puissance_10;

architecture Behavioral of puissance_10 is
signal buff : integer;
signal s_temperature : integer ;
signal c_cent : integer;
signal c_dix : integer;
signal c_un : integer;

type etat is (init, comp_cent, comp_dix, comp_un, sous_cent, sous_dix, sous_un, fin);
signal etatf : etat;
begin


blocM: process(rst, clk) -- Machine d etat Moore --> separer dizaine, centaine, unite
begin
if rst='1' then
	etatf<=init;
elsif rising_edge(clk) then
    case etatf is
	   when init => 
                   c_cent <= 0; 
                   c_dix <= 0; 
                   c_un <= 0;
                   s_temperature <= to_integer(signed(temperature));
                   etatf <= comp_cent;
	   when comp_cent => if s_temperature >= 100 then etatf <= sous_cent; -- on compare notre valeur a cent
	                       else etatf <= comp_dix;
	                       end if;
	   when sous_cent => -- Superieur a cent donc on compte nbre centaines
                    s_temperature <= s_temperature - 100;
                    c_cent <= c_cent +1; 
                    etatf <= comp_cent;
	   when comp_dix => if s_temperature >= 10 then etatf <= sous_dix;
	                       else etatf <= comp_un;
	                       end if;
	   when sous_dix => 
                    s_temperature <= s_temperature - 10;
                    c_dix <= c_dix +1;
                    etatf <= comp_dix;
	   when comp_un => if s_temperature >= 1 then etatf <= sous_un;
	                       else etatf <= fin;
	                       end if;
	   when sous_un => 
                    s_temperature <= s_temperature - 1;
                    c_un <= c_un +1;
                    etatf <= comp_un;
	   when fin =>  -- on retourne sur 4 bits les dizaines, centaines, unites
               centaine <= std_logic_vector(to_unsigned(c_dix, 4));
               dizaine <= std_logic_vector(to_unsigned(c_un,4));
               unite <= std_logic_vector(to_unsigned(0,4));
               etatf <= init;
	   when others => etatf <= init;                      
end case;
end if;
end process;

end Behavioral;
