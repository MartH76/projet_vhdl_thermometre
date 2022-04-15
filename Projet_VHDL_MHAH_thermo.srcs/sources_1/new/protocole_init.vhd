----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2022 09:54:00
-- Design Name: 
-- Module Name: protocole_init - Behavioral
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

entity protocole_init is --On fait une FSM de Mealy
Port (
    cmd_init : in std_logic; -- start du bloc init
    rst : in std_logic;
    clk : in std_logic;
    timer : in std_logic;
    oneW_in : in std_logic;
    oneW_out : out std_logic;
    cond_tri_state : out std_logic;
    init_done : out std_logic); -- bit de fin
end protocole_init;

architecture Behavioral of protocole_init is

type state IS (INIT, MASTER_RST, STATE_WAIT, READ, FIN_INIT) ;

signal current_state : state ;
signal start_cpt_480u : std_logic;
signal s_cpt_480u_end : std_logic;
signal start_cpt_60u : std_logic;
signal s_cpt_60u_end : std_logic;

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

U_compteur_60u : compteur
generic map(FIN_COMPTEUR => 60)
port map(
clk => clk,
rst => rst,
timer => timer,
start_compteur => start_cpt_60u,
compteur_end => s_cpt_60u_end);

U_compteur_480u : compteur
generic map(FIN_COMPTEUR => 480)
port map(
clk => clk,
rst => rst,
start_compteur => start_cpt_480u,
timer => timer,
compteur_end => s_cpt_480u_end);

process(rst, clk) is
begin
     if rst='1' then
          current_state <= INIT;
          cond_tri_state <= '0';
     elsif rising_edge(clk) then
          case current_state is
               when INIT => init_done <= '0'; -- on attend le start pour passer a master rst et lancer le cmpteur 480u
                            oneW_out <= '0';
                            if cmd_init = '1' then
                               current_state <= MASTER_RST;
                               cond_tri_state <= '1'; -- on pull down pendant 480 u  pour init l'init
                               oneW_out <= '0';  
                               start_cpt_60u <= '0';  
                               start_cpt_480u <= '1'; 
                          else current_state <= INIT;  
                               cond_tri_state <= '0';
                          end if;
                          
                          
               when MASTER_RST => if s_cpt_480u_end = '1' then -- on a attendu 480us
                                current_state <= STATE_WAIT;
                                start_cpt_480u <= '1';
                                start_cpt_60u <= '1';
                                cond_tri_state <= '0'; -- on relache la ligne et on attend 60u
                           end if;
              when STATE_WAIT => if  s_cpt_60u_end = '1' and oneW_in = '0' then --les 60u passées, on lit la valeur envoyée par le capteur
                              current_state <= READ; -- Le capteur a repondu 0, l'init s'est bien passé, on passe à la suite
                              start_cpt_60u <= '1';          
                                 else if s_cpt_60u_end = '1' and oneW_in = '1' then
                              current_state <= INIT; -- Le capteur n'as pas répondu, l'init n'a pas marché, on relance la séquence d'init
                                end if;  
                              end if;
              when READ => if s_cpt_60u_end = '1' and oneW_in = '0' then --On a encore attendu 60u, si la ligne est tjr à 0, l'init a marché, sinon, on la restart
                              current_state <= FIN_INIT;
                                else if s_cpt_60u_end = '1' and oneW_in = '1' then
                              current_state <= INIT; 
                              end if;
                           end if;
              when FIN_INIT => if  s_cpt_480u_end = '1' then -- après avoir attendu 480us, l'init est terminée, on peut renvoyer init_done
                                   current_state <= INIT;
                                   init_done <= '1';
                                   start_cpt_480u <= '0';
                                   start_cpt_60u <= '0';
                               end if;           
              when others => current_state <= INIT;
          end case;
     end if;
end process;

end Behavioral;