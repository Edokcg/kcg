--邪神 迪亚邦多
function c77239029.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c77239029.spcon)
	e2:SetOperation(c77239029.spop)
	c:RegisterEffect(e2)

	--不会被战斗破坏
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)

	--不受怪兽效果影响
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetValue(c77239029.efilter)
    c:RegisterEffect(e4)

    --装备
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_EQUIP)
    e5:SetCode(EVENT_BATTLE_DESTROYING)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCondition(c77239029.eqcon)
    e5:SetTarget(c77239029.eqtg)
    e5:SetOperation(c77239029.eqop)
    c:RegisterEffect(e5)	
end
----------------------------------------------------------------------------
function c77239029.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c77239029.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
----------------------------------------------------------------------------
function c77239029.efilter(e,te)
    return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
----------------------------------------------------------------------------
function c77239029.eqcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetBattleTarget()
    e:SetLabelObject(tc)
    return aux.bdogcon(e,tp,eg,ep,ev,re,r,rp)
end
function c77239029.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsHasEffect(77239054)
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    local tc=e:GetLabelObject()
    Duel.SetTargetCard(tc)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c77239029.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
        local atk=tc:GetBaseAttack()
        if atk<0 then atk=0 end
        if not Duel.Equip(tp,tc,c,false) then return end
        --Add Equip limit
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(c77239029.eqlimit)
        tc:RegisterEffect(e1)
        if atk>0 then
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_EQUIP)
            e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
            e2:SetCode(EFFECT_UPDATE_ATTACK)
            e2:SetReset(RESET_EVENT+0x1fe0000)
            e2:SetValue(500)
            tc:RegisterEffect(e2)
        end
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_EQUIP)
        e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetCode(6669251)
        e3:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e3)
		if c:IsFaceup() and tc:IsFaceup() then
            local code=tc:GetOriginalCode()
            local e4=Effect.CreateEffect(c)
            e4:SetType(EFFECT_TYPE_SINGLE)
            e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e4:SetCode(EFFECT_CHANGE_CODE)
            e4:SetValue(code)
            e4:SetReset(RESET_EVENT+0x1fe0000)
            c:RegisterEffect(e4)
            c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
        end
    end
end
function c77239029.eqlimit(e,c)
    return e:GetOwner()==c
end


