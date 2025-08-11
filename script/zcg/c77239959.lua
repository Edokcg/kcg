--黑魔導女孩 粉将(ZCG)
function c77239959.initial_effect(c)
    --battle indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e1:SetCountLimit(1)
    e1:SetValue(c77239959.valcon)
    c:RegisterEffect(e1)

    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)	
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)	
    e2:SetTarget(c77239959.sumtg)
    e2:SetOperation(c77239959.sumop)
    c:RegisterEffect(e2)	
end
------------------------------------------------------------------
function c77239959.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
------------------------------------------------------------------
function c77239959.cfilter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsDiscardable()
end
function c77239959.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c77239959.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77239959.sumop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c77239959.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
    local c=e:GetHandler()
    local tc=g:GetFirst()
    local code=tc:GetOriginalCode()	
    local atk=tc:GetBaseAttack()
    local def=tc:GetBaseDefense()
    local race=tc:GetRace()
    local att=tc:GetAttribute()
    local lv=tc:GetLevel()
    if e:GetHandler():IsRelateToEffect(e) and
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) then       
        --攻击力/守备力
		local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_SET_DEFENSE)
        e2:SetValue(def)		
        c:RegisterEffect(e2)
		--效果
		c:CopyEffect(code,RESET_EVENT+0x1fe0000)
		--等级
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CHANGE_LEVEL)
        e3:SetValue(lv)
        e3:SetReset(RESET_EVENT+0xff0000)
        c:RegisterEffect(e3)	
        --属性
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetRange(LOCATION_MZONE)
        e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
        e4:SetValue(att)
        e4:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e4)
		--种族
        local e5=Effect.CreateEffect(c)
        e5:SetType(EFFECT_TYPE_SINGLE)
        e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e5:SetCode(EFFECT_CHANGE_RACE)
        e5:SetValue(race)
        e5:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e5)
    end	
end

