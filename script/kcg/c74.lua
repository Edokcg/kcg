--D－HERO Bloo－D 
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83965310,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(83965310,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.eqcon)
	e3:SetTarget(s.eqtg)
	e3:SetOperation(s.eqop)
	c:RegisterEffect(e3)
	aux.AddEREquipLimit(c,s.eqcon,function(ec,_,tp) return ec:IsControler(1-tp) end,s.equipop,e3)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(s.efilter)
	c:RegisterEffect(e5)
		
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e100:SetRange(LOCATION_MZONE)
	e100:SetCode(EFFECT_CANNOT_DISABLE)
	e100:SetValue(1)
	c:RegisterEffect(e100)
	
	--特殊召唤不会被无效化
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e9)
end

function s.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),aux.TRUE,3,false,3,true,c,c:GetControler(),nil,false,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,3,3,false,true,true,c,nil,nil,false,nil)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function s.eqfilter(c)
	return c:GetFlagEffect(id)~=0 
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(s.eqfilter,nil)
	return #g==0
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		s.equipop(c,e,tp,tc)
	end
end
function s.equipop(c,e,tp,tc)
	local atk=tc:GetAttack()/2
	if tc:IsFacedown() then atk=0 end
	if atk<0 then atk=0 end
	if not c:EquipByEffectAndLimitRegister(e,tp,tc,id) then return end
	if atk>0 then
        local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
	end
    if tc:IsFaceup() then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EVENT_ADJUST)
		e3:SetRange(0x7f)
		e3:SetOperation(s.op)
		tc:RegisterEffect(e3)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipTarget()
	local o=e:GetOwner()
	local code=c:GetOriginalCode()
	if eq==o and eq:IsFaceup() and eq:GetFlagEffect(code)==0 and not eq:IsDisabled() then
		local cid=eq:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		eq:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,0,1)
		e:SetLabel(cid)
	end 
	if not eq or o~=eq or eq:IsDisabled() then
		local cid=e:GetLabel()
		o:ResetEffect(cid,RESET_COPY)
	end
	if not eq or o~=eq then
		e:Reset()
	end
end

function s.efilter(e,te)
	return not te:IsActiveType(TYPE_MONSTER) and te:GetHandler():GetControler()~=e:GetHandlerPlayer()
end
