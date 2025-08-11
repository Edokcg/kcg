--壓力Element (K)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(s.checkop)
	c:RegisterEffect(e2)
	--Destroy2
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(s.desop2)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
s.listed_names={347}

function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsCode(347)
end
function s.filter2(c,e,tp)
	return c:IsFaceup() and Duel.IsPlayerCanSpecialSummonMonster(tp,347,0,c:GetOriginalType(),c:GetBaseAttack()+500,c:GetBaseDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()==1-tp and s.filter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter2,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.filter2,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g:GetFirst(),1,0,0)
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=Duel.GetFirstTarget()
	if rc and rc:IsRelateToEffect(e) and rc:IsFaceup() then
	  if Duel.Equip(tp,c,rc) then
	  --Add Equip limit
	  local e1=Effect.CreateEffect(rc)
	  e1:SetType(EFFECT_TYPE_SINGLE)
	  e1:SetCode(EFFECT_EQUIP_LIMIT)
	  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	  e1:SetReset(RESET_EVENT+0x1fe0000)
	  e1:SetValue(s.eqlimit)
	  c:RegisterEffect(e1)
	  if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	  and Duel.IsPlayerCanSpecialSummonMonster(tp,347,0,rc:GetOriginalType(),rc:GetBaseAttack()+500,rc:GetBaseDefense(),rc:GetOriginalLevel(),rc:GetOriginalRace(),rc:GetOriginalAttribute())) then return end
	local tc2=Duel.CreateToken(tp,347)
	local ocode=rc:GetOriginalCode()
	if Duel.SpecialSummonStep(tc2,0,tp,tp,true,false,POS_FACEUP) then
        local effcode=ocode
        local rrealcode,orcode,rrealalias=rc:GetRealCode()
        if rrealcode>0 then 
            ocode=orcode
            effcode=0
        end
        if rrealcode>0 then
            tc2:SetEntityCode(ocode,nil,rc:GetOriginalSetCard(),rc:GetOriginalType()|TYPE_TOKEN|TYPE_EFFECT&~TYPE_NORMAL,nil,nil,nil,nil,nil,nil,nil,nil,false,347,effcode,347,rc)
            local te1={rc:GetFieldEffect()}
            local te2={rc:GetTriggerEffect()}
            for _,te in ipairs(te1) do
                if te:GetOwner()==rc then
                    local te2=te:Clone()
                    te2:SetOwner(tc2)
                    if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
                        local prop=te:GetProperty()
                        te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
                    end
                    tc2:RegisterEffect(te2,true)
                    te:Reset()
                end
            end
            for _,te in ipairs(te2) do
                if te:GetOwner()==rc then
                    local te2=te:Clone()
                    te2:SetOwner(tc2)
                    if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
                        local prop=te:GetProperty()
                        te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
                    end
                    tc2:RegisterEffect(te2,true)
                    te:Reset()
                end
            end
        else
            tc2:SetEntityCode(ocode,nil,rc:GetOriginalSetCard(),rc:GetOriginalType()|TYPE_TOKEN|TYPE_EFFECT&~TYPE_NORMAL,nil,nil,nil,nil,nil,nil,nil,nil,true,347,effcode,347)
        end
        aux.CopyCardTable(rc,tc2)
		local e0=Effect.CreateEffect(tc2)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_SET_BASE_ATTACK)
		e0:SetValue(math.max(rc:GetBaseAttack(),0)+500)
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
		tc2:CompleteProcedure() end  
		c:SetCardTarget(tc2) 
		end 
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