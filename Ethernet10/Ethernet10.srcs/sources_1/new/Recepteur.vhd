----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2022 15:37:14
-- Design Name: 
-- Module Name: Recepteur - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Recepteur is
    Port ( CLK      :   in  STD_LOGIC;
           RESET    :   in  STD_LOGIC;
           RBYTEP   :   out STD_LOGIC;
           RCLEANP  :   out STD_LOGIC;
           RCVNGP   :   out STD_LOGIC;
           RDATAO   :   out STD_LOGIC_VECTOR (7 downto 0);
           RDATAI   :   in STD_LOGIC_VECTOR (7 downto 0);
           RDONEP   :   out STD_LOGIC;
           RENABP   :   in  STD_LOGIC;
           RSTARTP  :   out STD_LOGIC;
           RSMATIP  :   out STD_LOGIC);
end Recepteur;

architecture Behavioral of Recepteur is

    signal AUX_RCVNGP: STD_LOGIC;
    signal AUX_RDONEP: STD_LOGIC;
    signal AUX_RCLEANP: STD_LOGIC;
    signal SFD: STD_LOGIC_VECTOR (7 downto 0) := "10101011";
    signal EFD: STD_LOGIC_VECTOR (7 downto 0) := "01010100";
    
    signal cpt_etape: STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal cpt_wait: STD_LOGIC_VECTOR (2 downto 0)  := "000";
    signal cpt_trame: integer range 5 downto 0      := 0;
    signal ADDRDEST: STD_LOGIC_VECTOR (47 downto 0) := X"ABCDEF102397";

begin

    RCVNGP  <= AUX_RCVNGP;
    RDONEP  <= AUX_RDONEP;
    RCLEANP <= AUX_RCLEANP;

Main : process

begin

    wait until CLK'Event and CLK='1';
    
    if (RESET = '0' or AUX_RDONEP = '1' or AUX_RCLEANP = '1') then
        RSTARTP <= '0';
        RSMATIP <= '0';
        AUX_RDONEP <='0';
        RDATAO <= "00000000";
        AUX_RCVNGP <= '0';
        RBYTEP <= '0';
        AUX_RCLEANP <= '0';
        cpt_wait <= "000";
        cpt_etape <= "000";
        cpt_trame <= 5;
    
    elsif (RENABP = '1' and AUX_RCVNGP = '0') then
        RSTARTP <= '1';
        AUX_RCVNGP <= '1';
        if (RDATAI = SFD) then  --verification SFD
            cpt_etape <= "000";
        else
            AUX_RCLEANP <= '1';
            AUX_RCVNGP <= '0';
            
        end if;    
    
    elsif (AUX_RCVNGP = '1') then
        
        if (cpt_wait = "000") then
            
            if (cpt_etape = "000") then     --verification @ destination
                RSTARTP <= '0';
                if (RDATAI = ADDRDEST((7+cpt_trame*8) downto (cpt_trame*8))) then
                    
                    if (cpt_trame = 0) then
                        RSMATIP <= '1';
                        cpt_etape <= "001";
                        cpt_trame <= 5;
                    else
                        cpt_trame <= cpt_trame-1;
                    
                    end if;
                
                else
                    AUX_RCLEANP <= '1';
                    AUX_RCVNGP <= '0';
                    
                end if;
            
            elsif(cpt_etape = "001") then      --envoi @source
                RDATAO <= RDATAI;
                RBYTEP <= '1';
                
                if (cpt_trame = 0) then
                    cpt_etape <= "010";
                    cpt_trame <= 5;
                    
                else
                    cpt_trame <= cpt_trame-1;
                                    
                end if;
           
            
            elsif(cpt_etape ="010") then        --envoi data
                
                if (RDATAI /= EFD) then
                    RDATAO <= RDATAI;
                    RBYTEP <= '1';
                                
                else
                    AUX_RCVNGP <= '0';
                    AUX_RDONEP <= '1';                
           
                end if;
                
            end if;
       

        end if;
        
        if (cpt_wait = "001") then
            RBYTEP <= '0';
            RSMATIP <= '0';
        end if;
        
        cpt_wait <= cpt_wait + 1;
                
    end if;

end process;

end Behavioral;
