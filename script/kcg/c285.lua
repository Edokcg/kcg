--Tyrant Burst Dragon
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,false,57470761,280)
	
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14745409,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(s.eqtg)
	e3:SetOperation(s.eqop)
	c:RegisterEffect(e3)

    --All Attack
    local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_ALL)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
s.listed_names={57470761,280}
s.material_trap=57470761

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) or c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(tc)
	e1:SetValue(s.eqlimit)
	c:RegisterEffect(e1)
	-- local e8 = Effect.CreateEffect(c)
	-- e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	-- e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	-- e8:SetCode(EVENT_LEAVE_FIELD_P)
	-- e8:SetOperation(s.recover)
	-- e8:SetLabel(tc:GetOriginalCode())
	-- e8:SetReset(RESET_EVENT + 0x1fe0000)
	-- c:RegisterEffect(e8, true)
	-- local e9 = Effect.CreateEffect(c)
	-- e9:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	-- e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- e9:SetCode(EVENT_LEAVE_FIELD_P)
	-- e9:SetRange(LOCATION_SZONE)
	-- e9:SetOperation(s.recover2)
	-- e9:SetLabel(tc:GetOriginalCode())
	-- e9:SetReset(RESET_EVENT+0x1fe0000)
	-- c:RegisterEffect(e9, true)
	local atk=tc:GetTextAttack()
	local def=tc:GetTextDefense()
	tc:SetEntityCode(363,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_OWNER_RELATE,RESET_EVENT+RESETS_STANDARD,c,true)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(atk+400)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	e3:SetValue(def+400)
	c:RegisterEffect(e3)
    --All Attack
    local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e4)
	-- --Unaffected by Trap effects
	-- local e5=Effect.CreateEffect(c)
	-- e5:SetType(EFFECT_TYPE_EQUIP)
	-- e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e5:SetRange(LOCATION_MZONE)
	-- e5:SetCode(EFFECT_IMMUNE_EFFECT)
	-- e5:SetValue(s.efilter)
	-- e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	-- c:RegisterEffect(e5)
	-- --Set Trap from GY
	-- local e6=Effect.CreateEffect(c)
	-- e6:SetDescription(aux.Stringid(11443677,0))
	-- e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	-- e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	-- e6:SetCode(EVENT_DAMAGE_STEP_END)
	-- e6:SetRange(LOCATION_SZONE)
	-- e6:SetCountLimit(1)
	-- e6:SetCondition(s.descon)
	-- e6:SetTarget(s.fgtg)
	-- e6:SetOperation(s.fgop)
	-- e6:SetReset(RESET_EVENT+RESETS_STANDARD)
	-- c:RegisterEffect(e6)
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function s.stfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec:IsRelateToBattle()
end
function s.fgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.stfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.stfilter,tp,LOCATION_GRAVE,0,1,nil)
		and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_REMOVE-RESET_LEAVE+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,s.stfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function s.fgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
	end
end

function s.filter2(c,ec,code)
	return c:GetEquipTarget()==ec and c:IsCode(code)
end
function s.recover(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local c=e:GetHandler()
	local ec=e:GetHandler():GetEquipTarget()
	if ec and not ec:IsOriginalCode(id) then
		ec:SetEntityCode(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
	end
end
function s.recover2(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local c=e:GetHandler()
	local ec=e:GetHandler():GetEquipTarget()
	if ec and eg:IsContains(ec) and not ec:IsOriginalCode(id) then
		ec:SetEntityCode(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
	end
end