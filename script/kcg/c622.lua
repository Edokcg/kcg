--合体魔竜ティマイオス
local s,id=GetID()
function s.initial_effect(c)
	s.efflist={}
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,{CARD_DARK_MAGICIAN,CARD_DARK_MAGICIAN_GIRL},s.ffilter2)
	
	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e00)
	
	--After this card is Special Summoned, until the end of your next turn, it is unaffected by other cards' effects
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(s.regop)
	c:RegisterEffect(e0)

	--Make this card gain 100 ATK for each Spell in the GYs and banishment
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)

	--Destroy 1 Spell/Trap on the field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E)
	e2:SetCountLimit(1)
	e2:SetCondition(function(e,tp) return Duel.IsTurnPlayer(1-tp) end)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(280,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.atarget)
	e3:SetOperation(s.aactivate)
	c:RegisterEffect(e3)
end
s.material={621}
s.listed_names={621,CARD_DARK_MAGICIAN,CARD_DARK_MAGICIAN_GIRL}

function s.ffilter2(c)
	return c:IsRace(RACE_DRAGON|RACE_SPELLCASTER) or c:IsCode(281)
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.IsTurnPlayer(tp) and 3 or 2
	--Unaffected by other cards' effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(3100)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(function(e,re) return e:GetHandler()~=re:GetOwner() end)
	e1:SetReset(RESETS_STANDARD_PHASE_END,ct)
	c:RegisterEffect(e1)
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSpell),tp,LOCATION_GRAVE|LOCATION_REMOVED,LOCATION_GRAVE|LOCATION_REMOVED,nil)
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,tp,100*ct)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSpell),tp,LOCATION_GRAVE|LOCATION_REMOVED,LOCATION_GRAVE|LOCATION_REMOVED,nil)
	if ct==0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		--Gains 100 ATK for each Spell in the GYs and banishment
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(100*ct)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsSpellTrap() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end


function s.filter(c,fc,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,fc,TYPE_FUSION|c:GetType())>0 
	and (c:IsControler(tp) or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
	and c:IsCanBeFusionMaterial() and (c:IsType(TYPE_XYZ) or c:IsAbleToGrave()) and not c:IsImmuneToEffect(e)
    and c:IsSetCard(0xa1)
end
function s.factivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ttp=c:GetControler()
	if not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e:GetHandler(),e,tp) or not Duel.IsPlayerCanSpecialSummon(tp,SUMMON_TYPE_FUSION,POS_FACEUP,tp,e:GetHandler()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local rg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e:GetHandler(),e,tp)
	if #rg<1 then return end
	local gc=rg:GetFirst()
	if gc:IsFacedown() then Duel.ConfirmCards(tp,gc) end
	local ttcode=841
	local code=gc:GetCode()
	local ocode=gc:GetOriginalCode()
    local acode=gc:GetOriginalAlias()
	local ralias=0
	local tc=Duel.CreateToken(tp,ttcode,nil,nil,nil,nil,nil,nil)
	local fg=rg
	fg:AddCard(c)
	local og=gc:GetOverlayGroup()
	if Duel.SendtoDeck(tc,tp,0,REASON_RULE+REASON_EFFECT)>0 then
		tc:SetMaterial(fg)
		if gc:IsType(TYPE_XYZ) and #og>0 then
			Duel.Overlay(tc,og)
		end
		Duel.SendtoGrave(fg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		if tc:IsCode(841) then
			local atk=gc:GetTextAttack()
			if atk<0 then atk=0 end
			local ss={gc:GetOriginalSetCard()}
			for index,value in pairs(ss) do
				if value==0xa1 then
					table.remove(ss,index)
				end
			end
            local addset=false
            if #ss>3 then
                addset=true
            else
                table.insert(ss,0x10a1)
            end
            local effcode=ocode
            local rrealcode,orcode,rrealalias=gc:GetRealCode()
            if rrealcode>0 then 
                ocode=orcode
                acode=orcode
                effcode=0
				ralias=rrealalias
			elseif gc:IsOriginalType(TYPE_NORMAL) then
                effcode=0
            end
            if rrealcode>0 then
                tc:SetEntityCode(ocode,nil,ss,(gc:GetOriginalType()|TYPE_EFFECT|TYPE_FUSION)&~TYPE_NORMAL&~TYPE_SPSUMMON,nil,nil,nil,atk+500,nil,nil,nil,nil,false,841,effcode,841,gc)
                local te1={gc:GetFieldEffect()}
                local te2={gc:GetTriggerEffect()}
                for _,te in ipairs(te1) do
                    if te:GetOwner()==gc then
                        local te2=te:Clone()
                        te2:SetOwner(tc)
                        if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
                            local prop=te:GetProperty()
                            te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
                        end
                        tc:RegisterEffect(te2,true)
                    end
                end
                for _,te in ipairs(te2) do
                    if te:GetOwner()==gc then
                        local te2=te:Clone()
                        te2:SetOwner(tc)
                        if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
                            local prop=te:GetProperty()
                            te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
                        end
                        tc:RegisterEffect(te2,true)
                    end
                end
            else
                tc:SetEntityCode(ocode,nil,ss,(gc:GetOriginalType()|TYPE_EFFECT|TYPE_FUSION)&~TYPE_NORMAL&~TYPE_SPSUMMON,nil,nil,nil,atk+500,nil,nil,nil,nil,true,841,effcode,841)
            end
            if addset then
                local e1=Effect.CreateEffect(tc)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
                e1:SetCode(EFFECT_ADD_SETCODE)
                e1:SetValue(0x10a1)
                tc:RegisterEffect(e1)
            end
            aux.CopyCardTable(gc,tc,"listed_names",id,code)
            tc.__index.material={code,id}

			local strong_eff_att={false,false,false}
			local strong_eff_immu1={false,false,false}
			local strong_eff_immu2={false,false,false}
			local strong_eff_weaken={false,false,false}
			local efftype={0,0,0} --0:Self Trigger, 1:Continuous, 2:Field Trigger
			local effcode={-1,-1,-1}
			local effcond={0,0,0} --0:No condition, 1:Easy condition, 2:Hard condition
			local effop={0,0,0}
			local effop={0,0,0}
			local effop={0,0,0}
			local effcount=1
			local effcounttype=0

			local lv=math.max(gc:GetOriginalLevel(),gc:GetOriginalRank(),gc:GetLinkMarker())
			if gc:IsOriginalType(TYPE_FUSION) and gc:GetLevel()<3 then lv=lv+3 end
			local effno=1
			if lv>6 then effno=2 
			elseif lv>9 then effno=3 end

			local duel_status=0
			local lastefftype=0
			local effevent={EVENT_BE_BATTLE_TARGET,EVENT_ATTACK_ANNOUNCE,EVENT_SPSUMMON_SUCCESS,EVENT_DESTROYED,EFFECT_TYPE_IGNITION,EVENT_CHAINING}
			local fieldeffevent={EVENT_BE_BATTLE_TARGET,EVENT_ATTACK_ANNOUNCE,EVENT_SPSUMMON_SUCCESS,EVENT_DRAW}
			if Duel.GetLP(ttp)<Duel.GetLP(ttp)-2000 then duel_status=duel_status+10 end
			if Duel.GetLP(ttp)<=2000 then duel_status=duel_status+20 end
			local opp_strong_att_count=Duel.GetMatchingGroupCount(s.strongatt,1-tp,LOCATION_MZONE,0,nil)
			local opp_strong_immu1_count=Duel.GetMatchingGroupCount(s.strongimmu1,1-tp,LOCATION_MZONE,0,nil)
			local opp_strong_immu2_count=Duel.GetMatchingGroupCount(s.strongimmu2,1-tp,LOCATION_MZONE,0,nil)
			local self_strong_att_count=Duel.GetMatchingGroupCount(s.strongatt,tp,LOCATION_MZONE,0,nil)
			local self_strong_immu1_count=Duel.GetMatchingGroupCount(s.strongimmu1,tp,LOCATION_MZONE,0,nil)
			local self_strong_immu2_count=Duel.GetMatchingGroupCount(s.strongimmu2,tp,LOCATION_MZONE,0,nil)
			local tot_att_count=opp_strong_att_count-self_strong_att_count
			local tot_immu1_count=opp_strong_immu1_count-self_strong_immu1_count
			local tot_immu2_count=opp_strong_immu2_count-self_strong_immu2_count
			if tot_att_count>0 then duel_status=duel_status+10 end
			if tot_immu1_count>0 then duel_status=duel_status+20 end
			if tot_immu2_count>0 then duel_status=duel_status+40 end
			local ecount={Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0),Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0),Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0),Duel.GetFieldGroupCount(1-tp,LOCATION_GRAVE,0),Duel.GetFieldGroupCount(1-tp,LOCATION_REMOVED,0)}
			local ecount2=ecount[1]
			local ecounttype=0
			for i=2,5 do
				if ecount[i]>ecount2 then 
					ecount2=ecount[i]
					ecounttype=i-1
				end
			end

			local hascodetable=false
			if s.efflist[code]~=nil then
				hascodetable=true
			end
			if not hascodetable then
				s.efflist[code]={}
				for i=1,effno do
					s.efflist[code][i]={}
				end
			end
			local te1={tc:GetFieldEffect()}
			local has_indeseff, has_indesbat, has_nottg, has_pierce=false, false, false, false
			for _,te in ipairs(te1) do
				if te:GetOwner()==tc then
					if te:GetCode()==EFFECT_INDESTRUCTABLE_EFFECT then has_indeseff=true end
					if te:GetCode()==EFFECT_INDESTRUCTABLE_BATTLE then has_indesbat=true end
					if te:GetCode()==EFFECT_CANNOT_BE_EFFECT_TARGET then has_nottg=true end
					if te:GetCode()==EFFECT_PIERCE then has_pierce=true end
				end
			end
			for i=1,effno do
				if hascodetable then
					strong_eff_att[i],strong_eff_immu1[i],strong_eff_immu2[i],strong_eff_weaken[i],efftype[i],effcode[i],effcond[i],effop[i],effcount,effcounttype=table.unpack(s.efflist[code][i])
				else
					local strong_eff=false
					local eff=lv/(math.max(lv,13))*100*0.4+duel_status*0.4+Duel.GetRandomNumber(0,10)*2
					if eff>39 then strong_eff=true end
					if strong_eff then
						local eff_att=opp_strong_att_count/Duel.GetMatchingGroupCount(s.strongatt,0,LOCATION_MZONE,LOCATION_MZONE,nil)*100*0.6+Duel.GetRandomNumber(0,100)*0.4
						local eff_immu1=opp_strong_immu1_count/Duel.GetMatchingGroupCount(s.strongimmu1,0,LOCATION_MZONE,LOCATION_MZONE,nil)*100*0.7+Duel.GetRandomNumber(0,100)*0.3
						local eff_immu2=opp_strong_immu2_count/Duel.GetMatchingGroupCount(s.strongimmu2,0,LOCATION_MZONE,LOCATION_MZONE,nil)*100*0.7+Duel.GetRandomNumber(0,100)*0.3
						if eff_att==math.max(eff_att,eff_immu1,eff_immu2) then
                            if Duel.GetRandomNumber(0,1)==1 then
                                strong_eff_weaken[i]=true
                            else
                                strong_eff_att[i]=true
                            end
						elseif eff_immu1==math.max(eff_att,eff_immu1,eff_immu2) then 
							strong_eff_immu1[i]=true 
						else
							strong_eff_immu2[i]=true
						end
					end
                    local typeno=Duel.GetRandomNumber(1,10)
					if typeno>6 then 
                        efftype[i]=1 
                        local typeno2=Duel.GetRandomNumber(1,10)
                        if typeno2>6 then 
                            efftype[i]=2
                            local eventno=Duel.GetRandomNumber(1,#fieldeffevent)
                            effcode[i]=fieldeffevent[eventno]
                        end
                    end
					if i>1 and lastefftype==0 then
                        local typeno2=Duel.GetRandomNumber(1,10)
                        if typeno2>6 then 
                            efftype[i]=2
                            local eventno=Duel.GetRandomNumber(1,#fieldeffevent)
                            effcode[i]=fieldeffevent[eventno]
                        else
                            efftype[i]=1
                        end
					end
					if efftype[i]==0 then
                        if opp_strong_immu1_count>0 then
                            efftype[i]=1
                            strong_eff_weaken[i]=true
                        else
                            local eventno=Duel.GetRandomNumber(1,#effevent)
                            effcode[i]=effevent[eventno]
                            if eventno>4 then
                                effcond[i]=Duel.GetRandomNumber(1,2)
                            end
                        end
					end
					effop[i]=Duel.GetRandomNumber(0,5)
                    if effop[i]==5 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then effop[i]=4 end
					if strong_eff_immu1[i] then
						if effop[i]<4 and has_indeseff then
							if not has_nottg then
								strong_eff_immu2[i]=true
								effop[i]=0
                            else
                                effop[i]=4
                            end
						end
					end
					if strong_eff_immu2[i] and effop[i]==0 and has_nottg then
						efftype[i]=0
                        local eventno=Duel.GetRandomNumber(1,#effevent)
						effcode[i]=effevent[eventno]
						if eventno>4 then
							effcond[i]=Duel.GetRandomNumber(1,2)
						end
					end
					lastefftype=efftype[i]
					effcount=ecount2
					effcounttype=ecounttype
					s.efflist[code][i]={strong_eff_att[i],strong_eff_immu1[i],strong_eff_immu2[i],strong_eff_weaken[i],efftype[i],effcode[i],effcond[i],effop[i],effcount,effcounttype}
				end
		    end
			for i=1,effno do
				local noeffect=false
				local prop=EFFECT_FLAG_CLIENT_HINT
				local e1=Effect.CreateEffect(tc)
				if efftype[i]==0 then
					e1:SetCode(effcode[i])
					if effcode[i]==EVENT_CHAINING then
						prop=prop|EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DAMAGE_CAL
						e1:SetType(EFFECT_TYPE_QUICK_O)
						e1:SetCode(EVENT_CHAINING)
						e1:SetRange(LOCATION_MZONE)
						if effcond[i]>0 then
							if effcond[i]==1 then
								e1:SetDescription(aux.Stringid(42,10),true)
								e1:SetCondition(s.discon2)
								e1:SetTarget(s.distg2)
								e1:SetOperation(s.disop2)
							else
								e1:SetDescription(aux.Stringid(42,11),true)
								e1:SetCondition(s.discon)
								e1:SetTarget(s.distg)
								e1:SetOperation(s.disop)
							end
						end
					else
						local desc={}
                        if effcode[i]==EVENT_BE_BATTLE_TARGET then 
							desc={aux.Stringid(281,5)}
						elseif effcode[i]==EVENT_ATTACK_ANNOUNCE then 
							desc={aux.Stringid(281,4)}
						elseif effcode[i]==EVENT_SPSUMMON_SUCCESS then 
							desc={aux.Stringid(281,6)}
						elseif effcode[i]==EVENT_DESTROYED then 
							desc={aux.Stringid(281,7)}
						elseif effcode[i]==EFFECT_TYPE_IGNITION then 
							desc={aux.Stringid(281,8)}
						end
                        if effcode[i]~=EFFECT_TYPE_IGNITION then 
                            e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
                        end
						e1:SetCode(effcode[i])
						if strong_eff_weaken[i] then
							if effop[i]==0 then
								e1:SetCategory(CATEGORY_DISABLE)
								e1:SetTarget(s.strongwkentarget)
								e1:SetOperation(s.strongwkenoperation)
								table.insert(desc,aux.Stringid(42,13))
							else
								e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
								e1:SetTarget(s.desatg)
								e1:SetOperation(s.desaop)
								table.insert(desc,aux.Stringid(42,14))
							end
						elseif strong_eff_att[i] then
							e1:SetCategory(CATEGORY_ATKCHANGE)
							e1:SetTarget(s.strongatktarget)
							e1:SetOperation(s.strongatkoperation)
							table.insert(desc,aux.Stringid(42,12))
						else
                            prop,desc=s.wkeffs(effop[i],e1,prop,desc,effcount,effcounttype)
						end
						table.insert(desc,2,true)
						e1:SetDescription(table.unpack(desc))
					end
				elseif efftype[i]==1 then
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetRange(LOCATION_MZONE)
					prop=prop|EFFECT_FLAG_SINGLE_RANGE
					if strong_eff_immu1[i] then
						if effop[i]>0 then
							if has_indeseff then
								noeffect=true
							end
							e1:SetDescription(aux.Stringid(42,4),true)
							e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
							e1:SetValue(1)
						elseif effop[i]==0 then
							if has_pierce then
								noeffect=true
							end
							e1:SetDescription(aux.Stringid(42,1),true)
							e1:SetCode(EFFECT_PIERCE)
						end
					elseif strong_eff_immu2[i] then
						if has_nottg then
							noeffect=true
						end
						e1:SetDescription(aux.Stringid(42,0),true)
						e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
						e1:SetValue(1)
					else
						if has_indesbat then
							noeffect=true
						end
						e1:SetDescription(aux.Stringid(42,2),true)
						e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
						e1:SetValue(1)
					end
                else
                    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
					e1:SetRange(LOCATION_MZONE)
                    e1:SetCode(effcode[i])
                    local desc={}
                    if effcode[i]==EVENT_BE_BATTLE_TARGET then 
                        desc={aux.Stringid(281,10)}
                        e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep==tp end)
                    elseif effcode[i]==EVENT_ATTACK_ANNOUNCE then 
                        desc={aux.Stringid(281,9)}
                        e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep==tp end)
                    elseif effcode[i]==EVENT_SPSUMMON_SUCCESS then 
                        desc={aux.Stringid(281,11)}
                        e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep==tp end)
                    elseif effcode[i]==EVENT_DRAW then
                        if effop[i]<2 then
                            desc={aux.Stringid(281,3)}
                            e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep~=tp end)
                        else
                            desc={aux.Stringid(281,12)}
                            e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep==tp end)
                        end
                    end
                    prop,desc=s.wkeffs(effop[i],e1,prop,desc,effcount,effcounttype)
                    table.insert(desc,2,true)
                    e1:SetDescription(table.unpack(desc))
				end
				e1:SetProperty(prop)
				if not noeffect then
					tc:RegisterEffect(e1)
				else
					e1:Reset()
				end
			end
		else
			local ss={tc:GetOriginalSetCard()}
            local addset=false
            if #ss>3 then
                addset=true
            else
                table.insert(ss,0x10a1)
            end
			tc:SetEntityCode(ttcode,nil,ss,tc:GetOriginalType()|TYPE_EFFECT|TYPE_FUSION,nil,nil,nil,nil,nil,nil,nil,nil,false,ttcode,ttcode,841,false,true)
            if addset then
                local e1=Effect.CreateEffect(tc)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
                e1:SetCode(EFFECT_ADD_SETCODE)
                e1:SetValue(0x10a1)
                tc:RegisterEffect(e1)
            end
		end
		--Unaffected by other cards' effects
		local e5=Effect.CreateEffect(tc)
		e5:SetDescription(aux.Stringid(622,2),true)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e5:SetCode(EFFECT_IMMUNE_EFFECT)
		e5:SetValue(function(e,re) return e:GetHandler()~=re:GetOwner() end)
		tc:RegisterEffect(e5)
		--Make this card gain 100 ATK for each Spell in the GYs and banishment
		local e6=Effect.CreateEffect(tc)
		e6:SetDescription(aux.Stringid(622,3),true)
		e6:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e6:SetCategory(CATEGORY_ATKCHANGE)
		e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		e6:SetCountLimit(1)
		e6:SetTarget(s.atktg)
		e6:SetOperation(s.atkop)
		tc:RegisterEffect(e6)
		--Destroy 1 Spell/Trap on the field
		local e7=Effect.CreateEffect(tc)
		e7:SetDescription(aux.Stringid(622,4),true)
		e7:SetCategory(CATEGORY_DESTROY)
		e7:SetType(EFFECT_TYPE_QUICK_O)
		e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e7:SetCode(EVENT_FREE_CHAIN)
		e7:SetRange(LOCATION_MZONE)
		e7:SetHintTiming(0,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E)
		e7:SetCountLimit(1)
		e7:SetCondition(function(e,tp) return Duel.IsTurnPlayer(1-tp) end)
		e7:SetTarget(s.destg)
		e7:SetOperation(s.desop)
		tc:RegisterEffect(e7)
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

function s.wkeffs(effop,e1,prop,desc,effcount,effcounttype)
	if effop<4 then 
		e1:SetLabel(effcount)
		if effcount>1 then 
			table.insert(desc,1,aux.Stringid(281,14))
			table.insert(desc,2,aux.Stringid(280,5+effcounttype))
			table.insert(desc,3,aux.Stringid(281,15))
		end
	end
    if effop==0 then
        e1:SetCategory(CATEGORY_REMOVE)
        e1:SetTarget(s.starget1)
        e1:SetOperation(s.soperation1)
        table.insert(desc,aux.Stringid(42,6))
    elseif effop==1 then
        e1:SetCategory(CATEGORY_DESTROY)
        e1:SetTarget(s.starget2)
        e1:SetOperation(s.soperation2)
        table.insert(desc,aux.Stringid(42,7))
    elseif effop==2 then
        e1:SetCategory(CATEGORY_DISABLE)
        e1:SetTarget(s.starget3)
        e1:SetOperation(s.soperation3)
        table.insert(desc,aux.Stringid(42,8))
    elseif effop==3 then
        e1:SetCategory(CATEGORY_ATKCHANGE)
        e1:SetTarget(s.starget4)
        e1:SetOperation(s.soperation4)
        table.insert(desc,aux.Stringid(42,9))
    elseif effop==4 then
        prop=prop|EFFECT_FLAG_PLAYER_TARGET
        e1:SetCategory(CATEGORY_DAMAGE)
        e1:SetTarget(s.damtg)
        e1:SetOperation(s.damop)
        table.insert(desc,aux.Stringid(42,15))
    elseif effop==5 then
        prop=prop|EFFECT_FLAG_PLAYER_TARGET
        e1:SetCategory(CATEGORY_DRAW)
        e1:SetTarget(s.drtg)
        e1:SetOperation(s.drop)
        table.insert(desc,aux.Stringid(42,5))
    end
    return prop,desc
end

function s.strongatt(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
	and c:GetAttack()>=3000
end
function s.strongimmu1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
	and c:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET)
end
function s.strongimmu2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
	and (c:IsHasEffect(EFFECT_IMMUNE_EFFECT) or c:IsHasEffect(EFFECT_GOD_IMMUNE))
end

function s.atkfilter(c)
	return c:GetAttack()>0 and c:IsFaceup()
end
function s.strongatktarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.strongatkoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for tc in aux.Next(Duel.GetMatchingGroup(s.atkfilter,tp,0,LOCATION_MZONE,nil)) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
	end
end

function s.wkenfilter(c)
	return not c:IsDisabled() and c:IsFaceup()
end
function s.strongwkentarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.wkenfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(s.wkenfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
end
function s.strongwkenoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for tc in aux.Next(Duel.GetMatchingGroup(s.wkenfilter,tp,0,LOCATION_MZONE,nil)) do
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
end

function s.desatg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desaop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

function s.sfilter1(c)
	return c:IsAbleToRemove()
end
function s.starget1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function s.soperation1(e,tp,eg,ep,ev,re,r,rp)
	local effcount=e:GetLabel()
	repeat
		effcount=effcount-1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.sfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if not g then return end
		Duel.Remove(g,nil,REASON_EFFECT)
	until effcount<1
	or not Duel.SelectYesNo(tp,210)
end

function s.sfilter2(c)
	return c:IsDestructable()
end
function s.starget2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function s.soperation2(e,tp,eg,ep,ev,re,r,rp)
	local effcount=e:GetLabel()
	repeat
		effcount=effcount-1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,s.sfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if not g then return end
		Duel.Destroy(g,REASON_EFFECT)
	until effcount<1
	or not Duel.SelectYesNo(tp,210)
end

function s.starget3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.wkenfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end
function s.soperation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local effcount=e:GetLabel()
	repeat
		effcount=effcount-1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectMatchingCard(tp,s.wkenfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		if not g then return end
		local tc=g:GetFirst()
		if tc and tc:IsFaceup() and not tc:IsDisabled() then
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT|RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
		end
	until effcount<1
	or not Duel.SelectYesNo(tp,210)
end

function s.sfilter4(c)
	return c:GetAttack()>0 and c:IsFaceup()
end
function s.starget4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter4,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,0)
end
function s.soperation4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local effcount=e:GetLabel()
	repeat
		effcount=effcount-1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectMatchingCard(tp,s.sfilter4,tp,0,LOCATION_MZONE,1,1,nil)
		if not g then return end
		local tc=g:GetFirst()
		local atk=tc:GetAttack()
		if tc and tc:IsFaceup() and atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(0)
			tc:RegisterEffect(e1)
		end
	until effcount<1
	or not Duel.SelectYesNo(tp,210)
end

function s.discon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev)
end
function s.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0
		and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		e:GetHandler():RegisterEffect(e1)
	end
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(Card.IsOnField,1,nil) and Duel.IsChainNegatable(ev)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function s.immval(e,te)
	local tc=te:GetOwner()
	local c=e:GetHandler()
	return c~=tc
end

function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end


function s.tgfilter(c,e,tp)
	return c:IsCanBeFusionMaterial() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.spfilter(c,e,tp,mc)
	if Duel.GetLocationCountFromEx(tp,tp,mc,c)<=0 then return false end
	local mustg=aux.GetMustBeMaterialGroup(tp,nil,tp,c,nil,REASON_FUSION)
	return c:IsType(TYPE_FUSION) and c:ListsCodeAsMaterial(mc:GetCode()) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and (#mustg==0 or (#mustg==1 and mustg:IsContains(mc)))
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if tc and tc:IsCanBeFusionMaterial() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst()
		if sc then
			sc:SetMaterial(Group.FromCards(tc))
			Duel.SendtoGrave(tc,REASON_EFFECT|REASON_MATERIAL|REASON_FUSION)
			Duel.BreakEffect()
			if Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) then
				sc:CompleteProcedure()
			end
		end
	end
end


function s.atarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e:GetHandler(),e,tp)
        and Duel.IsPlayerCanSpecialSummon(tp,SUMMON_TYPE_FUSION,POS_FACEUP,tp,e:GetHandler())
	local b2=Fusion.SummonEffTG(nil,nil)(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(44,2)},
		{b2,aux.Stringid(281,0)})
	if op==2 then
		Fusion.SummonEffTG(nil,nil)(e,tp,eg,ep,ev,re,r,rp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetTargetParam(op)
end
function s.aactivate(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if op==1 then
		s.factivate(e,tp,eg,ep,ev,re,r,rp)
	elseif op==2 then
		Fusion.SummonEffOP(nil,nil)(e,tp,eg,ep,ev,re,r,rp)
	end
end