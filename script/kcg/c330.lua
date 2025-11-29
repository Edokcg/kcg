--壓力胞子 (K)
local s,id=GetID()
function s.initial_effect(c)
	local e3=Effect.CreateEffect(c) 
	e3:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_OVERLAY)
	e3:SetOperation(s.efop)
	c:RegisterEffect(e3)
end
s.listed_names={342}

function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=eg:GetFirst()
	-- Duel.Hint(HINT_CARD,ep,330)
	if not (Duel.GetLocationCount(ep,LOCATION_MZONE)>0 and eqc
	  and Duel.IsPlayerCanSpecialSummonMonster(ep,347,0,eqc:GetOriginalType(),eqc:GetBaseAttack()+100,eqc:GetBaseDefense(),eqc:GetOriginalLevel(),eqc:GetOriginalRace(),eqc:GetOriginalAttribute())) then return end
	local tc2=Duel.CreateToken(ep,347)
	local ocode=eqc:GetOriginalCode()
	if Duel.SpecialSummonStep(tc2,0,ep,ep,true,false,POS_FACEUP) then
        local effcode=ocode
        local rrealcode,orcode,rrealalias=eqc:GetRealCode()
        if rrealcode>0 then 
            ocode=orcode
            effcode=0
        elseif eqc:IsOriginalType(TYPE_NORMAL) then
            effcode=0
        end
        if rrealcode>0 then
            tc2:SetEntityCode(ocode,nil,eqc:GetOriginalSetCard(),eqc:GetOriginalType()|TYPE_TOKEN|TYPE_EFFECT&~TYPE_NORMAL,nil,nil,nil,nil,nil,nil,nil,nil,false,347,effcode,347,eqc)
            local te1={eqc:GetFieldEffect()}
            local te2={eqc:GetTriggerEffect()}
            for _,te in ipairs(te1) do
                if te:GetOwner()==eqc then
                    local te2=te:Clone()
                    te2:SetOwner(tc2)
                    if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
                        local prop=te:GetProperty()
                        te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
                    end
                    tc2:RegisterEffect(te2,true)
                end
            end
            for _,te in ipairs(te2) do
                if te:GetOwner()==eqc then
                    local te2=te:Clone()
                    te2:SetOwner(tc2)
                    if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
                        local prop=te:GetProperty()
                        te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
                    end
                    tc2:RegisterEffect(te2,true)
                end
            end
        else
            tc2:SetEntityCode(ocode,nil,eqc:GetOriginalSetCard(),eqc:GetOriginalType()|TYPE_TOKEN|TYPE_EFFECT&~TYPE_NORMAL,nil,nil,nil,nil,nil,nil,nil,nil,true,347,effcode,347)
        end
        --aux.CopyCardTable(eqc,tc2)
		local mt=eqc:GetMetatable()
		local e0=Effect.CreateEffect(tc2)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_SET_BASE_ATTACK)
		e0:SetValue(math.max(eqc:GetBaseAttack(),0)+100)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e0,true)  
        if tc2:IsType(TYPE_XYZ) then
            local e7=Effect.CreateEffect(tc2)
            e7:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e7:SetDescription(aux.Stringid(347,0),true)
            e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
            e7:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
            e7:SetRange(LOCATION_MZONE)
            e7:SetCondition(s.rcon)
            e7:SetOperation(s.atktg) 
            tc2:RegisterEffect(e7,true) 
        end
		Duel.SpecialSummonComplete()
		tc2:CompleteProcedure() 
    end  
end

function s.rcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_COST)~=0 and re:GetHandler()==e:GetHandler()
	and c:GetFlagEffect(330)==0
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(330,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end