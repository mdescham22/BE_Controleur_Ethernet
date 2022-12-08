----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2022 17:19:03
-- Design Name: 
-- Module Name: Controleur_Ethernet - Behavioral
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

entity Controleur_Ethernet is
    
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           
           TABORTP : in STD_LOGIC;
           TAVAILP : in STD_LOGIC;
           TDATAI : in STD_LOGIC_VECTOR (7 downto 0);
           TDATAO : out STD_LOGIC_VECTOR (7 downto 0);
           TDONEP : out STD_LOGIC;
           TFINISHP : in STD_LOGIC;
           TLASTP : in STD_LOGIC;
           TREADDP : out STD_LOGIC;
           TRNSMTP : out STD_LOGIC;
           TSTARTP : out STD_LOGIC;
           
           RBYTEP   :   out STD_LOGIC;
           RCLEANP  :   out STD_LOGIC;
           RCVNGP   :   out STD_LOGIC;
           RDATAO   :   out STD_LOGIC_VECTOR (7 downto 0);
           RDATAI   :   in STD_LOGIC_VECTOR (7 downto 0);
           RDONEP   :   out STD_LOGIC;
           RENABP   :   in  STD_LOGIC;
           RSTARTP  :   out STD_LOGIC;
           RSMATIP  :   out STD_LOGIC);

end Controleur_Ethernet;

architecture struct of Controleur_Ethernet is
    
    component Recepteur
        port (rCLK      :   in  STD_LOGIC;
              rRESET    :   in  STD_LOGIC;
              rRBYTEP   :   out STD_LOGIC;
              rRCLEANP  :   out STD_LOGIC;
              rRCVNGP   :   out STD_LOGIC;
              rRDATAO   :   out STD_LOGIC_VECTOR (7 downto 0);
              rRDATAI   :   in STD_LOGIC_VECTOR (7 downto 0);
              rRDONEP   :   out STD_LOGIC;
              rRENABP   :   in  STD_LOGIC;
              rRSTARTP  :   out STD_LOGIC;
              rRSMATIP  :   out STD_LOGIC);
    end component;
    
    component Emetteur
        port (eCLK      :   in STD_LOGIC;
              eRESET    :   in STD_LOGIC;
              eTABORTP  :   in STD_LOGIC;
              eTAVAILP  :   in STD_LOGIC;
              eTFINISHP :   in STD_LOGIC;
              eTLASTP   :   in STD_LOGIC;
              eTDATAI   :   in STD_LOGIC_VECTOR (7 downto 0);
              
              eTREADDP  :   out STD_LOGIC;
              eTRNSMTP  :   out STD_LOGIC;
              eTSTARTP  :   out STD_LOGIC;
              eTDONEP   :   out STD_LOGIC;
              eTDATAO   :   out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component Collision
        port (cCLK     :  in STD_LOGIC;
              cRESET   :  in STD_LOGIC;
              cRCVNGP  :  in STD_LOGIC;
              cTRNSMTP :  in STD_LOGIC;
              cRENABP  :  out  STD_LOGIC;
              cTABORTP :  out STD_LOGIC);
    end component;
    
    signal rcvng, trnsmt, renab, tabort : STD_LOGIC;
    
begin

U1 : Emetteur port map(CLK,RESET,TABORTP,TAVAILP,TFINISHP,TLASTP,TDATAI,TREADDP,TRNSMTP,TSTARTP,TDONEP,TDATAO);

U2 : Recepteur port map(CLK,RESET,RBYTEP,RCLEANP,RCVNGP,RDATAO,RDATAI,RDONEP,RENABP,RSTARTP,RSMATIP);

U3 : Collision port map(CLK,RESET,rcvng,trnsmt,renab,tabort);

end struct;


architecture Behavioral of Emetteur is

signal AUX_TRNSMTP: STD_LOGIC;
    signal AUX_TDONEP: STD_LOGIC;
    signal SFD: STD_LOGIC_VECTOR (7 downto 0)       := "10101011";
    signal EFD: STD_LOGIC_VECTOR (7 downto 0)       := "01010100";
    signal ADDR: STD_LOGIC_VECTOR (47 downto 0)     := X"ABCDEF102397";
    signal cpt_wait: STD_LOGIC_VECTOR (2 downto 0)  := "000";
    signal cpt_trame: integer range 5 downto 0      := 0;
    signal cpt_etape: STD_LOGIC_VECTOR (2 downto 0) := "000";
    
begin

    TRNSMTP <=  AUX_TRNSMTP;
    TDONEP  <=  AUX_TDONEP;

Main : process

begin
    
    wait until CLK'Event and CLK='1';
    
    if (RESET = '0') then
        TREADDP     <=  '0';
        TDATAO      <=  "00000000";
        TSTARTP     <=  '0';
        AUX_TRNSMTP <=  '0';
        AUX_TDONEP  <=  '0';
        cpt_wait    <=  "000";
        cpt_trame   <=  0;
        cpt_etape   <=  "000";
    
    elsif (TABORTP='1' or TFINISHP='1') then
        AUX_TDONEP <= '1';
       
    elsif (AUX_TDONEP = '1') then
        TREADDP     <=  '0';
        TDATAO      <=  "00000000";
        TSTARTP     <=  '0';
        AUX_TRNSMTP <=  '0';
        AUX_TDONEP  <=  '0';
        cpt_wait    <=  "000";
        cpt_trame   <=  0;
        cpt_etape   <=  "000";
   
    elsif (TAVAILP='1' and AUX_TDONEP='0' and AUX_TRNSMTP = '0') then
        TSTARTP <= '1';
        AUX_TRNSMTP <='1';
    
    elsif (AUX_TRNSMTP = '1' and AUX_TDONEP = '0') then
        if (cpt_wait="00") then
                
            if(cpt_etape="000") then -- trame addr SFD
               TSTARTP <= '0';
               TDATAO <= SFD;
               cpt_etape <= "001";
               cpt_trame <= 5;
            
            elsif (cpt_etape="001") then -- trame addr destination
               TREADDP <= '1';
               TDATAO <= TDATAI;
               if (cpt_trame = 0) then
                    cpt_etape <= "010";
                    cpt_trame <= 5;
               else
                cpt_trame <= cpt_trame-1;
               end if;
                
            elsif(cpt_etape="010") then -- trame addr source
                TREADDP <= '0';
                TDATAO <= ADDR((7+cpt_trame*8) downto (cpt_trame*8)); 
                if (cpt_trame = 0) then
                    cpt_etape <= "011";
                    cpt_trame <= 0;
                else
                    cpt_trame <= cpt_trame-1;    
                end if; 
                
            elsif(cpt_etape="011") then -- trame addr donnée
                if (TLASTP='0') then 
                    TREADDP <= '1';
                    TDATAO <= TDATAI;
                else
                    TREADDP <= '0';
                    TDATAO <= EFD;
                    cpt_etape <= "100";
                end if;    
           
            elsif(cpt_etape="100") then -- trame addr fin
                    AUX_TDONEP <= '1';         
            end if;
           
        else
            TREADDP <= '0';
        
        end if;
        cpt_wait<=cpt_wait+1;
    
    end if;
    
end process;

end Behavioral;

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

