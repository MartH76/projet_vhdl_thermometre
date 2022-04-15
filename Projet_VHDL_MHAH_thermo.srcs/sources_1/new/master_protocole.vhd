----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.02.2022 15:15:55
-- Design Name: 
-- Module Name: master_protocole - Behavioral
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

entity master_protocole is
Port (clk : in std_logic;
      rst : in std_logic;
      init_done : in std_logic;
      write_8b_done : in std_logic;
      read_8b_done : in std_logic;
      start_protocole : in std_logic;
      timer : in std_logic;
      oneW_in : in std_logic;
      word_read : in std_logic_vector(7 downto 0);
      temp : out std_logic_vector(15 downto 0);
      
      ready : out std_logic;
      cmd_init : out std_logic;
      start_read : out std_logic;
      start_write : out std_logic;
     
      word_write : out std_logic_vector(7 downto 0)
      );
     
end master_protocole;



architecture Behavioral of master_protocole is
type state is (START, INIT, SKIP_ROM,INIT_2, SKIP_ROM_2,  CONVERT, START_CONVERT, INTERROGATION,START_READ_SCRATCHPAD, READ_SCRATCHPAD, READ_8BIT, TEMPERATURE, END_STATE);

signal current_state : state;
signal start_cpt_800m : std_logic;
signal s_cpt_800m_end : std_logic;
signal temph : std_logic_vector(7 downto 0);
signal templ : std_logic_vector(7 downto 0);
signal nbr_byte_lu : integer;
signal nbr_byte_lu_buf : integer;

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


U_compteur_800m : compteur
generic map(FIN_COMPTEUR => 800000)
port map(
clk => clk,
rst => rst,
timer => timer,
start_compteur => start_cpt_800m,
compteur_end => s_cpt_800m_end);

process(rst, clk) is
begin
     if rst='1' then
          current_state <= START;
     elsif rising_edge(clk) then
          case current_state is
               when START =>
                             cmd_init <= '0';
                             start_write <= '0';
                             start_read <= '0';
                             nbr_byte_lu <= 0;
                             word_write <= "00000000";
                             ready <= '0';
                             nbr_byte_lu_buf <= 0;
                             if start_protocole = '1' then -- On attend le start pour lancer le protocole
                                        current_state <= INIT; -- On lance l'init
                                        cmd_init <= '1';
                             end if;
               when INIT => cmd_init <= '0';
                            if init_done = '1' then  -- Quand l'init est finie, on passe à SKIP ROM                              
                                current_state <= SKIP_ROM;
                            end if;
               when SKIP_ROM => word_write <= "11001100"; --skip rom
                               start_write <= '1'; -- On lance l'ecriture de la commmande skip rom
                               if write_8b_done = '1' then  -- une fois l'ecriture finie, on pase à la conversion
                                     start_write <= '0';
                                     current_state <= START_CONVERT;
                               end if; 
               when START_CONVERT => word_write <= "01000100"; --ecrire 44h
                                     start_write <= '1';
                                     current_state <= CONVERT;-- On lance l'ecriture de la cmd START_CONVERT
               when CONVERT => 
                               start_write <= '0';
                               start_cpt_800m <= '1'; -- On lance le compteur 800ms, qui est la limite de temp pour la conversion
                               if write_8b_done = '1' then 
                                    current_state <= INTERROGATION;                                    
                               end if;
               when INTERROGATION => if s_cpt_800m_end = '1' then -- Si on a passé 800ms sans reponse du slave, on relance toute la conversion
                                        current_state <= INIT;
                                        cmd_init <= '1';
                                     else if oneW_in = '1' then -- Si le slave repond avant 800ms, on passe a la suite avec le deuxieme init
                                         current_state <= INIT_2;
                                         cmd_init <= '1';
                                         end if;
                                     end if;
               when INIT_2 => cmd_init <= '0';
                            if init_done = '1' then                                 
                                current_state <= SKIP_ROM_2;
                            end if;
               when SKIP_ROM_2 => word_write <= "11001100"; --skip rom
                                 start_write <= '1';
                               if write_8b_done = '1' then
                                     start_write <= '0';
                                     current_state <= START_READ_SCRATCHPAD;
                               end if;
               when START_READ_SCRATCHPAD =>     word_write <= "10111110"; --ecrire BEh
                                                  start_write <= '1'; -- On lance l'ecriture de la cmd READ_SCRATCHPAD
                                                  current_state <= READ_SCRATCHPAD;   
               when READ_SCRATCHPAD => 
                                       start_write <= '0';
                                       if write_8b_done = '1' then --Une fois l'ecriture finie, on va lire la temp renvoyee
                                            current_state <= READ_8BIT;
                                            start_write <= '0';
                                        end if;
               when READ_8BIT => start_read <= '1';
                                nbr_byte_lu_buf <=  nbr_byte_lu;
                                if read_8b_done = '1' then 
                                      start_read <= '0';
                                      case nbr_byte_lu is --petit fsm pour lire plusieurs byte (on peut facilement en lire plus suivant l'aplication)
                                         when 0 => temph <=  word_read;
                                                   nbr_byte_lu <= nbr_byte_lu_buf +1;
                                         when 1 => templ <=  word_read;
                                                   nbr_byte_lu <= nbr_byte_lu_buf +1;
                                                   current_state <= END_STATE;
                                         when others => nbr_byte_lu <= nbr_byte_lu_buf;
                                      end case;
                                   end if;
                when END_STATE => temp <= temph & templ; -- on renvoie la température sur 2 bytes
                                  ready <= '1';  
                                  current_state <= START;                                        
                when others => current_state <= START;                      
      end case;     
   end if;        
end process;
end Behavioral;
