----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.02.2022 08:11:29
-- Design Name: 
-- Module Name: write_8b - Behavioral
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

entity write_8b is
Port (
    rst : in std_logic;
    clk : in std_logic;
    word : in std_logic_vector (7 downto 0); --mot à écrire
    start : in std_logic; -- start du write
    timer : in std_logic; -- timer_1us
    oneW_out : out std_logic;
    cond_tri_state : out std_logic;
    write_8b_done : out std_logic);
end write_8b;

architecture Behavioral of write_8b is

type state is (INIT, READ_BIT,INIT_WRITE_0, WRITE_0, END_WRITE_0, INIT_WRITE_1, WRITE_1, END_WRITE_1, INC, WAIT_FOR_1U, FIN);

signal current_state : state ;
signal bit_selec : integer;
signal bit_selec_buffer : integer;
signal start_cpt_61u : std_logic;
signal cpt_61u_end : std_logic;

component compteur is
generic(FIN_COMPTEUR : integer);
Port ( 
clk : in std_logic;
rst : in std_logic;
timer : in std_logic;
start_compteur : in std_logic;
compteur_end : out std_logic);
end component;


begin

U_compteur_61u : compteur
generic map(FIN_COMPTEUR => 61)
port map(
clk => clk,
rst => rst,
timer => timer,
start_compteur => start_cpt_61u,
compteur_end => cpt_61u_end);


process(rst, clk) is
begin
     if rst='1' then
          current_state <= INIT;
          write_8b_done <= '0';
          cond_tri_state <= '0';
          bit_selec <= 0;
     elsif rising_edge(clk) then
          case current_state is
               when INIT =>  write_8b_done <= '0'; --on est à init en attendant un start
                             cond_tri_state <= '0';
                             oneW_out <= '0';
                             bit_selec <= 0;
                             bit_selec_buffer <= 0;
                          if start='1' then
                               current_state <= READ_BIT;
                          else current_state <= INIT; 
                          end if;
                when READ_BIT => -- on lit le bit d'indice bit selec du mot à écrire
                           bit_selec_buffer <= bit_selec;
                           if word(bit_selec)='0' and timer = '1' then --on veut que la ligne soit lachée pendant 1us entre le INIT_WRITE et le write
                                current_state <= INIT_WRITE_0;                           
                            else if word(bit_selec) = '1'  and timer = '1' then
                                current_state <= INIT_WRITE_1; 
                            else current_state <= READ_BIT;
                            end if;
                           end if;
                when INIT_WRITE_1 =>  cond_tri_state <= '1'; --on prend la main sur la ligne             
                                      oneW_out <= '0';      -- pull down avant de commencer la nouvelle écriture
                                      start_cpt_61u <= '1'; --on démarre le compteur 61us
                                      if timer = '1' then  --des qu'on a passé la us on commence l'écriture
                                          current_state <= WRITE_1;
                                      else current_state <= INIT_WRITE_1;
                                      end if;
                when WRITE_1 => cond_tri_state <= '1'; --on écrit un 1 pendant 60us
                                oneW_out <= '1';
                                if cpt_61u_end = '1' then 
                                    current_state <= END_WRITE_1;
                                else current_state <= WRITE_1;
                                end if;
               when END_WRITE_1 => cond_tri_state <= '0'; --on perd le controlede la ligne
                                if timer = '1' then
                                    current_state <= INC;
                                else current_state <= END_WRITE_1; 
                                start_cpt_61u <= '0'; --on stop le compteur
                                end if; 
                                
                when INIT_WRITE_0 =>  cond_tri_state <= '1';          --meme commentaires que pour le write 1    
                                      oneW_out <= '0';
                                      start_cpt_61u <= '1';
                                      if timer = '1' then 
                                          current_state <= WRITE_0;
                                      else current_state <= INIT_WRITE_0;
                                      end if;
                when WRITE_0 => cond_tri_state <= '1';
                                oneW_out <= '0';
                                if cpt_61u_end = '1' then 
                                    current_state <= END_WRITE_0;
                                else current_state <= WRITE_0;
                                end if;
               when END_WRITE_0 => cond_tri_state <= '0';
                                if timer = '1' then
                                    current_state <= INC;
                                else current_state <= END_WRITE_0;
                                start_cpt_61u <= '0'; 
                                end if; 
               when INC => bit_selec <= bit_selec_buffer + 1; --on incrémente la valeur du nbr de bit ecrit
                           current_state <= WAIT_FOR_1U; 
               when WAIT_FOR_1U => 
                                if timer = '1' and bit_selec = 8 then --si on a ecrit 8 bits 
                                    current_state <= FIN; --fin
                                else if timer = '1' and bit_selec < 8 then --sinon on reprend une ecriture d'1 bit
                                    current_state <= READ_BIT; 
                                else current_state <= WAIT_FOR_1U; 
                                end if;
                                end if;                     
               when FIN => write_8b_done <= '1'; --on renvoie le done de fin
                           current_state <= INIT;
               when others => current_state <= INIT;                      
               end case;
     end if;
end process;
end Behavioral;
